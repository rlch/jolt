use jolt_core::{JoltError, JsRuntime, JsValue};
use rquickjs::{Context, Function, Module, Runtime, Value, function::Args};

use crate::convert::{from_js_value, to_js_value, JsValueWrapper};

pub struct QuickJsRuntime {
    runtime: Runtime,
    context: Context,
}

impl QuickJsRuntime {
    pub fn new() -> Result<Self, JoltError> {
        let runtime =
            Runtime::new().map_err(|e| JoltError::RuntimeError(format!("Failed to create QuickJS runtime: {e}")))?;
        let context = Context::full(&runtime)
            .map_err(|e| JoltError::RuntimeError(format!("Failed to create QuickJS context: {e}")))?;
        Ok(Self { runtime, context })
    }

    /// Drive the microtask queue to completion.
    fn drain_jobs(&self) {
        while self.runtime.is_job_pending() {
            if self.runtime.execute_pending_job().is_err() {
                break;
            }
        }
    }
}

impl JsRuntime for QuickJsRuntime {
    fn eval(&mut self, code: &str) -> Result<JsValue, JoltError> {
        let code = code.to_owned();
        self.context.with(|ctx| {
            let val: Value = ctx.eval(code).map_err(|e| {
                let msg = format!("{e}");
                let stack = ctx.catch().as_string().and_then(|s| s.to_string().ok());
                JoltError::EvalError {
                    message: msg,
                    stack,
                }
            })?;
            to_js_value(&ctx, val)
        })
    }

    fn eval_async(&mut self, code: &str) -> Result<JsValue, JoltError> {
        let code = code.to_owned();

        // Get the promise inside with(), then drain jobs outside, then resolve inside with()
        let promise = self.context.with(|ctx| {
            let p: rquickjs::Promise = ctx.eval_promise(code).map_err(|e| {
                JoltError::EvalError {
                    message: e.to_string(),
                    stack: None,
                }
            })?;
            Ok::<_, JoltError>(rquickjs::Persistent::save(&ctx, p))
        })?;

        self.drain_jobs();

        self.context.with(|ctx| {
            let promise: rquickjs::Promise = promise.restore(&ctx)
                .map_err(|e| JoltError::RuntimeError(e.to_string()))?;
            let val: Value = promise.finish().map_err(|e| {
                JoltError::EvalError {
                    message: e.to_string(),
                    stack: None,
                }
            })?;
            to_js_value(&ctx, val)
        })
    }

    fn call_function(&mut self, name: &str, args: &[JsValue]) -> Result<JsValue, JoltError> {
        let name = name.to_owned();
        let args_owned = args.to_vec();
        self.context.with(|ctx| {
            let globals = ctx.globals();
            let func: Function = globals.get(&*name).map_err(|_| {
                JoltError::FunctionNotFound(name.clone())
            })?;

            let mut js_args = Args::new(ctx.clone(), args_owned.len());
            for a in &args_owned {
                let v = from_js_value(&ctx, a)?;
                js_args.push_arg(v).map_err(|e| {
                    JoltError::ConversionError(format!("Failed to push arg: {e}"))
                })?;
            }

            let result: Value = func.call_arg(js_args).map_err(|e| {
                JoltError::EvalError {
                    message: e.to_string(),
                    stack: None,
                }
            })?;
            to_js_value(&ctx, result)
        })
    }

    fn set_global(&mut self, name: &str, value: JsValue) -> Result<(), JoltError> {
        let name = name.to_owned();
        self.context.with(|ctx| {
            let globals = ctx.globals();
            let val = from_js_value(&ctx, &value)?;
            globals.set(&*name, val).map_err(|e| {
                JoltError::RuntimeError(format!("Failed to set global '{name}': {e}"))
            })
        })
    }

    fn get_global(&mut self, name: &str) -> Result<JsValue, JoltError> {
        let name = name.to_owned();
        self.context.with(|ctx| {
            let globals = ctx.globals();
            let val: Value = globals.get(&*name).map_err(|e| {
                JoltError::RuntimeError(format!("Failed to get global '{name}': {e}"))
            })?;
            to_js_value(&ctx, val)
        })
    }

    fn register_function<F>(&mut self, name: &str, f: F) -> Result<(), JoltError>
    where
        F: Fn(Vec<JsValue>) -> Result<JsValue, JoltError> + Send + 'static,
    {
        let name = name.to_owned();
        self.context.with(|ctx| {
            let func = Function::new(ctx.clone(), move |args: rquickjs::function::Rest<JsValueWrapper>| -> rquickjs::Result<JsValueWrapper> {
                let converted_args: Vec<JsValue> = args.0.into_iter().map(|w| w.0).collect();
                f(converted_args)
                    .map(JsValueWrapper)
                    .map_err(|_e| rquickjs::Error::new_from_js("callback", "JsValue"))
            })
            .map_err(|e| JoltError::RuntimeError(format!("Failed to create function: {e}")))?;

            let globals = ctx.globals();
            globals.set(&*name, func).map_err(|e| {
                JoltError::RuntimeError(format!("Failed to register function '{name}': {e}"))
            })
        })
    }

    fn eval_module(&mut self, code: &str, module_name: &str) -> Result<JsValue, JoltError> {
        let code = code.to_owned();
        let module_name = module_name.to_owned();

        let promise = self.context.with(|ctx| {
            let p = Module::evaluate(ctx.clone(), module_name, code).map_err(|e| {
                JoltError::EvalError {
                    message: e.to_string(),
                    stack: None,
                }
            })?;
            Ok::<_, JoltError>(rquickjs::Persistent::save(&ctx, p))
        })?;

        self.drain_jobs();

        self.context.with(|ctx| {
            let promise: rquickjs::Promise = promise.restore(&ctx)
                .map_err(|e| JoltError::RuntimeError(e.to_string()))?;
            let val: Value = promise.finish().map_err(|e| {
                JoltError::EvalError {
                    message: e.to_string(),
                    stack: None,
                }
            })?;
            to_js_value(&ctx, val)
        })
    }
}

// Safety: QuickJS runtime is single-threaded but we hold exclusive &mut self access
// through the JsRuntime trait, and rquickjs with "parallel" feature provides Send.
unsafe impl Send for QuickJsRuntime {}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_eval_number() {
        let mut rt = QuickJsRuntime::new().unwrap();
        let result = rt.eval("1 + 1").unwrap();
        assert_eq!(result, JsValue::Int(2));
    }

    #[test]
    fn test_eval_string() {
        let mut rt = QuickJsRuntime::new().unwrap();
        let result = rt.eval("'hello' + ' world'").unwrap();
        assert_eq!(result, JsValue::String("hello world".to_owned()));
    }

    #[test]
    fn test_eval_float() {
        let mut rt = QuickJsRuntime::new().unwrap();
        let result = rt.eval("3.14").unwrap();
        assert_eq!(result, JsValue::Float(3.14));
    }

    #[test]
    fn test_eval_bool() {
        let mut rt = QuickJsRuntime::new().unwrap();
        assert_eq!(rt.eval("true").unwrap(), JsValue::Bool(true));
        assert_eq!(rt.eval("false").unwrap(), JsValue::Bool(false));
    }

    #[test]
    fn test_eval_null_undefined() {
        let mut rt = QuickJsRuntime::new().unwrap();
        assert_eq!(rt.eval("null").unwrap(), JsValue::Null);
        assert_eq!(rt.eval("undefined").unwrap(), JsValue::Undefined);
    }

    #[test]
    fn test_eval_array() {
        let mut rt = QuickJsRuntime::new().unwrap();
        let result = rt.eval("[1, 2, 3]").unwrap();
        assert_eq!(
            result,
            JsValue::Array(vec![JsValue::Int(1), JsValue::Int(2), JsValue::Int(3)])
        );
    }

    #[test]
    fn test_set_get_global() {
        let mut rt = QuickJsRuntime::new().unwrap();
        rt.set_global("greeting", JsValue::String("hello".to_owned())).unwrap();
        let result = rt.eval("greeting.toUpperCase()").unwrap();
        assert_eq!(result, JsValue::String("HELLO".to_owned()));
    }

    #[test]
    fn test_get_global() {
        let mut rt = QuickJsRuntime::new().unwrap();
        rt.eval("var x = 42").unwrap();
        let result = rt.get_global("x").unwrap();
        assert_eq!(result, JsValue::Int(42));
    }

    #[test]
    fn test_call_function() {
        let mut rt = QuickJsRuntime::new().unwrap();
        rt.eval("function add(a, b) { return a + b; }").unwrap();
        let result = rt.call_function("add", &[JsValue::Int(2), JsValue::Int(3)]).unwrap();
        assert_eq!(result, JsValue::Int(5));
    }

    #[test]
    fn test_register_function() {
        let mut rt = QuickJsRuntime::new().unwrap();
        rt.register_function("double", |args| {
            let n = args[0].as_i64().unwrap();
            Ok(JsValue::Int(n * 2))
        })
        .unwrap();
        let result = rt.eval("double(21)").unwrap();
        assert_eq!(result, JsValue::Int(42));
    }

    #[test]
    fn test_eval_error() {
        let mut rt = QuickJsRuntime::new().unwrap();
        let result = rt.eval("throw new Error('boom')");
        assert!(result.is_err());
    }

    #[test]
    fn test_eval_object() {
        let mut rt = QuickJsRuntime::new().unwrap();
        let result = rt.eval("({a: 1, b: 'two'})").unwrap();
        match result {
            JsValue::Object(entries) => {
                assert!(entries.iter().any(|e| e.key == "a" && e.value == JsValue::Int(1)));
                assert!(entries.iter().any(|e| e.key == "b" && e.value == JsValue::String("two".to_owned())));
            }
            other => panic!("Expected object, got {other:?}"),
        }
    }
}
