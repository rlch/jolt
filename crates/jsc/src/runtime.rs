use jolt_core::{JoltError, JsRuntime, JsValue};
use rusty_jsc::{callback, JSContext, JSValue, JSValue as JscValue};

use crate::convert::{from_js_value, to_js_value};

type ClosureFn = dyn Fn(Vec<JsValue>) -> Result<JsValue, JoltError> + Send + 'static;

/// C trampoline for registered functions.
/// First arg (via .bind()) is a f64-encoded pointer to the boxed closure.
#[callback]
fn registered_fn_trampoline(
    ctx: JSContext,
    _function: JSObject,
    _this: JSObject,
    args: &[JscValue],
) -> Result<JscValue, JscValue> {
    // Helper to invoke the closure — avoids `return` in callback block
    fn invoke(ctx: &JSContext, args: &[JscValue]) -> Result<JscValue, JscValue> {
        if args.is_empty() {
            return Err(JscValue::string(ctx, "missing closure pointer"));
        }

        let ptr_val = args[0]
            .to_number(ctx)
            .map_err(|_| JscValue::string(ctx, "invalid closure pointer"))?
            as usize;

        let closure: &Box<ClosureFn> = unsafe { &*(ptr_val as *const Box<ClosureFn>) };

        let mut js_args = Vec::with_capacity(args.len() - 1);
        for arg in &args[1..] {
            match to_js_value(ctx, arg) {
                Ok(v) => js_args.push(v),
                Err(e) => {
                    let msg = format!("arg conversion: {e}");
                    return Err(JscValue::string(ctx, msg.as_str()));
                }
            }
        }

        match closure(js_args) {
            Ok(result) => from_js_value(ctx, &result).map_err(|e| {
                let msg = format!("result conversion: {e}");
                JscValue::string(ctx, msg.as_str())
            }),
            Err(e) => {
                let msg = format!("{e}");
                Err(JscValue::string(ctx, msg.as_str()))
            }
        }
    }
    invoke(&ctx, args)
}

fn register_function_impl<F>(context: &mut JSContext, name: &str, f: F) -> Result<(), JoltError>
where
    F: Fn(Vec<JsValue>) -> Result<JsValue, JoltError> + Send + 'static,
{
    let boxed: Box<ClosureFn> = Box::new(f);
    let raw_ptr = Box::into_raw(Box::new(boxed));
    let ptr_val = raw_ptr as usize;

    // Create callback, then .bind(null, ptr_val) to bake the closure pointer
    let callback_val = JscValue::callback(context, Some(registered_fn_trampoline));
    let callback_obj = callback_val
        .to_object(context)
        .map_err(|e: JscValue| {
            let msg = e.to_string(context).map(|s| s.to_string()).unwrap_or_default();
            JoltError::RuntimeError(msg)
        })?;

    let bind_fn = callback_obj
        .get_property(context, "bind")
        .to_object(context)
        .map_err(|e: JscValue| {
            let msg = e.to_string(context).map(|s| s.to_string()).unwrap_or_default();
            JoltError::RuntimeError(msg)
        })?;

    let bound = bind_fn
        .call(
            context,
            Some(&callback_obj),
            &[
                JscValue::undefined(context),
                JscValue::number(context, ptr_val as f64),
            ],
        )
        .map_err(|e: JscValue| {
            let msg = e.to_string(context).map(|s| s.to_string()).unwrap_or_default();
            JoltError::RuntimeError(msg)
        })?;

    let global = context.get_global_object();
    global
        .set_property(context, name, bound)
        .map_err(|e: JscValue| {
            let msg = e.to_string(context).map(|s| s.to_string()).unwrap_or_default();
            JoltError::RuntimeError(msg)
        })
}

pub struct JscRuntime {
    context: JSContext,
}

impl JscRuntime {
    pub fn new() -> Result<Self, JoltError> {
        Ok(Self {
            context: JSContext::default(),
        })
    }

    fn jsc_err_to_jolt(&self, err: JscValue) -> JoltError {
        let message = err
            .to_string(&self.context)
            .map(|s| s.to_string())
            .unwrap_or_else(|_| "Unknown JS error".to_owned());
        JoltError::EvalError {
            message,
            stack: None,
        }
    }
}

impl JsRuntime for JscRuntime {
    fn eval(&mut self, code: &str) -> Result<JsValue, JoltError> {
        let result = self
            .context
            .evaluate_script(code, 1)
            .map_err(|e| self.jsc_err_to_jolt(e))?;
        to_js_value(&self.context, &result)
    }

    fn eval_async(&mut self, code: &str) -> Result<JsValue, JoltError> {
        // JSC doesn't have a built-in promise resolution mechanism in rusty_jsc.
        // For now, evaluate and return the result directly.
        // Full async/promise support requires polling the JSC run loop.
        self.eval(code)
    }

    fn call_function(&mut self, name: &str, args: &[JsValue]) -> Result<JsValue, JoltError> {
        let global = self.context.get_global_object();
        let func_val = global.get_property(&self.context, name);

        if func_val.is_undefined(&self.context) {
            return Err(JoltError::FunctionNotFound(name.to_owned()));
        }

        let func_obj = func_val
            .to_object(&self.context)
            .map_err(|e| self.jsc_err_to_jolt(e))?;

        let jsc_args: Vec<JscValue> = args
            .iter()
            .map(|a| from_js_value(&self.context, a))
            .collect::<Result<_, _>>()?;

        let result = func_obj
            .call(&self.context, None, &jsc_args)
            .map_err(|e| self.jsc_err_to_jolt(e))?;

        to_js_value(&self.context, &result)
    }

    fn set_global(&mut self, name: &str, value: JsValue) -> Result<(), JoltError> {
        let global = self.context.get_global_object();
        let jsc_val = from_js_value(&self.context, &value)?;
        global
            .set_property(&self.context, name, jsc_val)
            .map_err(|e| self.jsc_err_to_jolt(e))
    }

    fn get_global(&mut self, name: &str) -> Result<JsValue, JoltError> {
        let global = self.context.get_global_object();
        let val = global.get_property(&self.context, name);
        to_js_value(&self.context, &val)
    }

    fn register_function<F>(&mut self, name: &str, f: F) -> Result<(), JoltError>
    where
        F: Fn(Vec<JsValue>) -> Result<JsValue, JoltError> + Send + 'static,
    {
        register_function_impl(&mut self.context, name, f)
    }

    fn eval_module(&mut self, code: &str, _module_name: &str) -> Result<JsValue, JoltError> {
        // JSC's C API doesn't expose module evaluation directly through rusty_jsc.
        // Evaluate as a regular script for now.
        self.eval(code)
    }
}

unsafe impl Send for JscRuntime {}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_eval_number() {
        let mut rt = JscRuntime::new().unwrap();
        let result = rt.eval("1 + 1").unwrap();
        assert_eq!(result, JsValue::Int(2));
    }

    #[test]
    fn test_eval_string() {
        let mut rt = JscRuntime::new().unwrap();
        let result = rt.eval("'hello' + ' world'").unwrap();
        assert_eq!(result, JsValue::String("hello world".to_owned()));
    }

    #[test]
    fn test_eval_float() {
        let mut rt = JscRuntime::new().unwrap();
        let result = rt.eval("3.14").unwrap();
        assert_eq!(result, JsValue::Float(3.14));
    }

    #[test]
    fn test_eval_bool() {
        let mut rt = JscRuntime::new().unwrap();
        assert_eq!(rt.eval("true").unwrap(), JsValue::Bool(true));
        assert_eq!(rt.eval("false").unwrap(), JsValue::Bool(false));
    }

    #[test]
    fn test_eval_null_undefined() {
        let mut rt = JscRuntime::new().unwrap();
        assert_eq!(rt.eval("null").unwrap(), JsValue::Null);
        assert_eq!(rt.eval("undefined").unwrap(), JsValue::Undefined);
    }

    #[test]
    fn test_eval_array() {
        let mut rt = JscRuntime::new().unwrap();
        let result = rt.eval("[1, 2, 3]").unwrap();
        assert_eq!(
            result,
            JsValue::Array(vec![JsValue::Int(1), JsValue::Int(2), JsValue::Int(3)])
        );
    }

    #[test]
    fn test_set_get_global() {
        let mut rt = JscRuntime::new().unwrap();
        rt.set_global("greeting", JsValue::String("hello".to_owned())).unwrap();
        let result = rt.eval("greeting.toUpperCase()").unwrap();
        assert_eq!(result, JsValue::String("HELLO".to_owned()));
    }

    #[test]
    fn test_call_function() {
        let mut rt = JscRuntime::new().unwrap();
        rt.eval("function add(a, b) { return a + b; }").unwrap();
        let result = rt.call_function("add", &[JsValue::Int(2), JsValue::Int(3)]).unwrap();
        assert_eq!(result, JsValue::Int(5));
    }

    #[test]
    fn test_eval_error() {
        let mut rt = JscRuntime::new().unwrap();
        let result = rt.eval("throw new Error('boom')");
        assert!(result.is_err());
    }

    #[test]
    fn test_register_function_basic() {
        let mut rt = JscRuntime::new().unwrap();
        rt.register_function("add_one", |args| {
            let n = args.first().and_then(|v| v.as_i64()).unwrap_or(0);
            Ok(JsValue::Int(n + 1))
        })
        .unwrap();
        let result = rt.eval("add_one(41)").unwrap();
        assert_eq!(result, JsValue::Int(42));
    }

    #[test]
    fn test_register_function_string() {
        let mut rt = JscRuntime::new().unwrap();
        rt.register_function("greet", |args| {
            let name = args
                .first()
                .and_then(|v| v.as_str())
                .unwrap_or("world")
                .to_owned();
            Ok(JsValue::String(format!("hello {name}")))
        })
        .unwrap();
        let result = rt.eval("greet('rust')").unwrap();
        assert_eq!(result, JsValue::String("hello rust".to_owned()));
    }

    #[test]
    fn test_register_function_no_args() {
        let mut rt = JscRuntime::new().unwrap();
        rt.register_function("get_pi", |_args| Ok(JsValue::Float(3.14)))
            .unwrap();
        let result = rt.eval("get_pi()").unwrap();
        assert_eq!(result, JsValue::Float(3.14));
    }

    #[test]
    fn test_register_function_called_from_js_function() {
        let mut rt = JscRuntime::new().unwrap();
        rt.register_function("double", |args| {
            let n = args.first().and_then(|v| v.as_i64()).unwrap_or(0);
            Ok(JsValue::Int(n * 2))
        })
        .unwrap();
        rt.eval("function quadruple(x) { return double(double(x)); }")
            .unwrap();
        let result = rt.eval("quadruple(5)").unwrap();
        assert_eq!(result, JsValue::Int(20));
    }

    #[test]
    fn test_eval_object() {
        let mut rt = JscRuntime::new().unwrap();
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
