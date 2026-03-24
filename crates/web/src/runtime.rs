use jolt_core::{JoltError, JsResultFuture, JsRuntime, JsValue};
use wasm_bindgen::prelude::*;

use crate::convert::{from_js_value, to_js_value};

pub struct WebRuntime {
    /// Stored closures for registered functions — prevents memory leaks.
    /// Without this, `Closure::forget()` would permanently leak each closure.
    _closures: Vec<Closure<dyn Fn(wasm_bindgen::JsValue) -> wasm_bindgen::JsValue>>,
}

impl WebRuntime {
    pub fn new() -> Result<Self, JoltError> {
        Ok(Self {
            _closures: Vec::new(),
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
        let closure = Closure::wrap(Box::new(move |args: wasm_bindgen::JsValue| -> wasm_bindgen::JsValue {
            let js_args = js_sys::Array::from(&args);
            let converted: Vec<JsValue> = (0..js_args.length())
                .filter_map(|i| to_js_value(&js_args.get(i)).ok())
                .collect();
            match f(converted) {
                Ok(val) => from_js_value(&val).unwrap_or(wasm_bindgen::JsValue::undefined()),
                Err(e) => {
                    // Throw a JS Error so callers can detect failure
                    let err = js_sys::Error::new(&e.to_string());
                    wasm_bindgen::throw_val(err.into())
                }
            }
        }) as Box<dyn Fn(wasm_bindgen::JsValue) -> wasm_bindgen::JsValue>);

        let global = js_sys::global();
        js_sys::Reflect::set(
            &global,
            &wasm_bindgen::JsValue::from_str(name),
            closure.as_ref(),
        )
        .map_err(|e| JoltError::RuntimeError(format!("Failed to register function: {:?}", e)))?;

        // Store the closure to keep it alive (dropped with the runtime)
        self._closures.push(closure);
        Ok(())
    }

    fn eval_module(&mut self, code: &str, _module_name: &str) -> Result<JsValue, JoltError> {
        // In browser context, module evaluation requires dynamic import
        // which is async. Fall back to eval for now.
        self.eval(code)
    }
}

unsafe impl Send for WebRuntime {}
