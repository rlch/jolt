use jolt_core::{JoltError, JsResultFuture, JsRuntime, JsValue};
use wasm_bindgen::prelude::*;

use crate::convert::{from_js_value, to_js_value};

pub struct WebRuntime {
    /// Stored closures for registered functions — prevents memory leaks.
    _closures_variadic: Vec<Closure<dyn Fn(js_sys::Array) -> wasm_bindgen::JsValue>>,
}

impl WebRuntime {
    pub fn new() -> Result<Self, JoltError> {
        Ok(Self {
            _closures_variadic: Vec::new(),
        })
    }
}

impl JsRuntime for WebRuntime {
    fn eval(&mut self, code: &str) -> Result<JsValue, JoltError> {
        let result = js_sys::eval(code).map_err(|e| JoltError::EvalError {
            message: format!("{:?}", e),
            stack: None,
        })?;
        to_js_value(&result)
    }

    fn eval_async(&mut self, code: &str) -> JsResultFuture<'_> {
        let result = js_sys::eval(code).map_err(|e| JoltError::EvalError {
            message: format!("{:?}", e),
            stack: None,
        });

        Box::pin(async move {
            let val = result?;

            // If the result is a Promise, await it via wasm-bindgen-futures
            if val.is_instance_of::<js_sys::Promise>() {
                let promise = js_sys::Promise::from(val);
                let resolved = wasm_bindgen_futures::JsFuture::from(promise)
                    .await
                    .map_err(|e| JoltError::EvalError {
                        message: format!("{:?}", e),
                        stack: None,
                    })?;
                to_js_value(&resolved)
            } else {
                to_js_value(&val)
            }
        })
    }

    fn call_function(&mut self, name: &str, args: &[JsValue]) -> Result<JsValue, JoltError> {
        let global = js_sys::global();
        let func = js_sys::Reflect::get(&global, &wasm_bindgen::JsValue::from_str(name))
            .map_err(|_| JoltError::FunctionNotFound(name.to_owned()))?;

        let func = js_sys::Function::from(func);
        let js_args = js_sys::Array::new_with_length(args.len() as u32);
        for (i, arg) in args.iter().enumerate() {
            js_args.set(i as u32, from_js_value(arg)?);
        }

        let result = func.apply(&wasm_bindgen::JsValue::undefined(), &js_args)
            .map_err(|e| JoltError::EvalError {
                message: format!("{:?}", e),
                stack: None,
            })?;

        to_js_value(&result)
    }

    fn set_global(&mut self, name: &str, value: JsValue) -> Result<(), JoltError> {
        let global = js_sys::global();
        let js_val = from_js_value(&value)?;
        js_sys::Reflect::set(&global, &wasm_bindgen::JsValue::from_str(name), &js_val)
            .map_err(|e| JoltError::RuntimeError(format!("Failed to set global: {:?}", e)))?;
        Ok(())
    }

    fn get_global(&mut self, name: &str) -> Result<JsValue, JoltError> {
        let global = js_sys::global();
        let val = js_sys::Reflect::get(&global, &wasm_bindgen::JsValue::from_str(name))
            .map_err(|e| JoltError::RuntimeError(format!("Failed to get global: {:?}", e)))?;
        to_js_value(&val)
    }

    fn register_function<F>(&mut self, name: &str, f: F) -> Result<(), JoltError>
    where
        F: Fn(Vec<JsValue>) -> Result<JsValue, JoltError> + Send + 'static,
    {
        // Create a closure that receives a js_sys::Array of arguments.
        let closure = Closure::wrap(Box::new(move |args: js_sys::Array| -> wasm_bindgen::JsValue {
            let converted: Vec<JsValue> = (0..args.length())
                .filter_map(|i| to_js_value(&args.get(i)).ok())
                .collect();
            match f(converted) {
                Ok(val) => from_js_value(&val).unwrap_or(wasm_bindgen::JsValue::undefined()),
                Err(e) => {
                    let err = js_sys::Error::new(&e.to_string());
                    wasm_bindgen::throw_val(err.into())
                }
            }
        }) as Box<dyn Fn(js_sys::Array) -> wasm_bindgen::JsValue>);

        // Create a JS wrapper that collects variadic arguments into an Array
        // and forwards them to the Rust closure: function() { return __f(Array.from(arguments)); }
        let inner_name = format!("__jolt_inner_{name}");
        let global = js_sys::global();
        js_sys::Reflect::set(
            &global,
            &wasm_bindgen::JsValue::from_str(&inner_name),
            closure.as_ref(),
        )
        .map_err(|e| JoltError::RuntimeError(format!("Failed to set inner function: {:?}", e)))?;

        let wrapper_body = format!("return globalThis.{inner_name}(Array.from(arguments))");
        let wrapper = js_sys::Function::new_no_args(&wrapper_body);
        js_sys::Reflect::set(
            &global,
            &wasm_bindgen::JsValue::from_str(name),
            &wrapper,
        )
        .map_err(|e| JoltError::RuntimeError(format!("Failed to register function: {:?}", e)))?;

        // Store the closure to keep it alive (dropped with the runtime)
        self._closures_variadic.push(closure);
        Ok(())
    }

    fn eval_module(&mut self, code: &str, _module_name: &str) -> Result<JsValue, JoltError> {
        // In browser context, module evaluation requires dynamic import
        // which is async. Fall back to eval for now.
        self.eval(code)
    }
}

unsafe impl Send for WebRuntime {}

#[cfg(test)]
mod tests {
    use super::*;
    use wasm_bindgen_test::*;

    #[wasm_bindgen_test]
    fn test_eval_number() {
        let mut rt = WebRuntime::new().unwrap();
        let result = rt.eval("1 + 1").unwrap();
        assert_eq!(result, JsValue::Int(2));
    }

    #[wasm_bindgen_test]
    fn test_eval_string() {
        let mut rt = WebRuntime::new().unwrap();
        let result = rt.eval("'hello' + ' world'").unwrap();
        assert_eq!(result, JsValue::String("hello world".to_owned()));
    }

    #[wasm_bindgen_test]
    fn test_eval_float() {
        let mut rt = WebRuntime::new().unwrap();
        let result = rt.eval("3.14").unwrap();
        assert_eq!(result, JsValue::Float(3.14));
    }

    #[wasm_bindgen_test]
    fn test_eval_bool() {
        let mut rt = WebRuntime::new().unwrap();
        assert_eq!(rt.eval("true").unwrap(), JsValue::Bool(true));
        assert_eq!(rt.eval("false").unwrap(), JsValue::Bool(false));
    }

    #[wasm_bindgen_test]
    fn test_eval_null_undefined() {
        let mut rt = WebRuntime::new().unwrap();
        assert_eq!(rt.eval("null").unwrap(), JsValue::Null);
        assert_eq!(rt.eval("undefined").unwrap(), JsValue::Undefined);
    }

    #[wasm_bindgen_test]
    fn test_eval_array() {
        let mut rt = WebRuntime::new().unwrap();
        let result = rt.eval("[1, 2, 3]").unwrap();
        assert_eq!(
            result,
            JsValue::Array(vec![JsValue::Int(1), JsValue::Int(2), JsValue::Int(3)])
        );
    }

    #[wasm_bindgen_test]
    fn test_eval_object() {
        let mut rt = WebRuntime::new().unwrap();
        let result = rt.eval("({a: 1, b: 'two'})").unwrap();
        match result {
            JsValue::Object(entries) => {
                assert!(entries.iter().any(|e| e.key == "a" && e.value == JsValue::Int(1)));
                assert!(entries
                    .iter()
                    .any(|e| e.key == "b" && e.value == JsValue::String("two".to_owned())));
            }
            other => panic!("Expected object, got {other:?}"),
        }
    }

    #[wasm_bindgen_test]
    fn test_eval_error() {
        let mut rt = WebRuntime::new().unwrap();
        let result = rt.eval("throw new Error('boom')");
        assert!(result.is_err());
    }

    #[wasm_bindgen_test]
    fn test_set_get_global() {
        let mut rt = WebRuntime::new().unwrap();
        rt.set_global("__test_greeting", JsValue::String("hello".to_owned()))
            .unwrap();
        let result = rt.eval("__test_greeting.toUpperCase()").unwrap();
        assert_eq!(result, JsValue::String("HELLO".to_owned()));
    }

    #[wasm_bindgen_test]
    fn test_call_function() {
        let mut rt = WebRuntime::new().unwrap();
        // Use globalThis to ensure function is on the global object in Node
        rt.eval("globalThis.__test_add = function(a, b) { return a + b; }")
            .unwrap();
        let result = rt
            .call_function("__test_add", &[JsValue::Int(2), JsValue::Int(3)])
            .unwrap();
        assert_eq!(result, JsValue::Int(5));
    }

    #[wasm_bindgen_test]
    fn test_register_function() {
        let mut rt = WebRuntime::new().unwrap();
        rt.register_function("__test_double", |args| {
            let n = args.first().and_then(|v| v.as_i64()).unwrap_or(0);
            Ok(JsValue::Int(n * 2))
        })
        .unwrap();
        let result = rt.eval("__test_double(21)").unwrap();
        assert_eq!(result, JsValue::Int(42));
    }

    #[wasm_bindgen_test]
    async fn test_eval_async_promise() {
        let mut rt = WebRuntime::new().unwrap();
        let result = rt.eval_async("Promise.resolve(42)").await.unwrap();
        assert_eq!(result, JsValue::Int(42));
    }

    #[wasm_bindgen_test]
    async fn test_eval_async_chained_promise() {
        let mut rt = WebRuntime::new().unwrap();
        let result = rt
            .eval_async("Promise.resolve(10).then(x => x * 2).then(x => x + 1)")
            .await
            .unwrap();
        assert_eq!(result, JsValue::Int(21));
    }

    #[wasm_bindgen_test]
    async fn test_eval_async_non_promise() {
        let mut rt = WebRuntime::new().unwrap();
        let result = rt.eval_async("1 + 1").await.unwrap();
        assert_eq!(result, JsValue::Int(2));
    }

    #[wasm_bindgen_test]
    async fn test_eval_async_rejected_promise() {
        let mut rt = WebRuntime::new().unwrap();
        let result = rt.eval_async("Promise.reject('boom')").await;
        assert!(result.is_err());
    }
}
