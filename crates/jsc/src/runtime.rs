use std::ffi::c_void;
use std::sync::Once;

use jolt_core::{JoltError, JsResultFuture, JsRuntime, JsValue};
use rusty_jsc::{callback, JSContext, JSValue, JSValue as JscValue};
use rusty_jsc_sys::{JSContextGetGroup, JSContextGroupRef, JSGlobalContextRef};

use crate::convert::{from_js_value, to_js_value};

// ---- drainMicrotasks via dlsym ----

type DrainMicrotasksFn = unsafe extern "C" fn(*mut c_void);

static INIT_DRAIN: Once = Once::new();
static mut DRAIN_MICROTASKS: Option<DrainMicrotasksFn> = None;

fn get_drain_microtasks() -> Option<DrainMicrotasksFn> {
    INIT_DRAIN.call_once(|| {
        let sym = unsafe {
            libc::dlsym(
                libc::RTLD_DEFAULT,
                c"_ZN3JSC2VM15drainMicrotasksEv".as_ptr(),
            )
        };
        if !sym.is_null() {
            unsafe {
                DRAIN_MICROTASKS = Some(
                    std::mem::transmute::<*mut libc::c_void, DrainMicrotasksFn>(sym),
                )
            };
        }
    });
    unsafe { DRAIN_MICROTASKS }
}

/// Drain the JSC microtask queue (promise resolution).
///
/// Uses `JSContextGetGroup()` (public C API) to obtain `VM*`, then calls
/// the C++ symbol `JSC::VM::drainMicrotasks()` resolved via `dlsym`.
/// Falls back to no-op if the symbol is unavailable.
fn drain_jsc_microtasks(raw_ctx: JSGlobalContextRef) {
    if let Some(drain) = get_drain_microtasks() {
        let group: JSContextGroupRef = unsafe { JSContextGetGroup(raw_ctx as _) };
        unsafe { drain(group as *mut c_void) };
    }
}

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

        let closure: &ClosureFn = unsafe { &**(ptr_val as *const Box<ClosureFn>) };

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

fn register_function_impl<F>(
    context: &mut JSContext,
    name: &str,
    f: F,
) -> Result<*mut Box<ClosureFn>, JoltError>
where
    F: Fn(Vec<JsValue>) -> Result<JsValue, JoltError> + Send + 'static,
{
    let boxed: Box<ClosureFn> = Box::new(f);
    let raw_ptr = Box::into_raw(Box::new(boxed));
    let ptr_val = raw_ptr as usize;

    // Create callback, then .bind(null, ptr_val) to bake the closure pointer
    let callback_val = JscValue::callback(context, Some(registered_fn_trampoline));
    let callback_obj = callback_val.to_object(context).map_err(|e: JscValue| {
        let msg = e
            .to_string(context)
            .map(|s| s.to_string())
            .unwrap_or_default();
        JoltError::RuntimeError(msg)
    })?;

    let bind_fn = callback_obj
        .get_property(context, "bind")
        .to_object(context)
        .map_err(|e: JscValue| {
            let msg = e
                .to_string(context)
                .map(|s| s.to_string())
                .unwrap_or_default();
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
            let msg = e
                .to_string(context)
                .map(|s| s.to_string())
                .unwrap_or_default();
            JoltError::RuntimeError(msg)
        })?;

    let global = context.get_global_object();
    global
        .set_property(context, name, bound)
        .map_err(|e: JscValue| {
            // Clean up the raw pointer on failure
            unsafe { drop(Box::from_raw(raw_ptr)) };
            let msg = e
                .to_string(context)
                .map(|s| s.to_string())
                .unwrap_or_default();
            JoltError::RuntimeError(msg)
        })?;
    Ok(raw_ptr)
}

pub struct JscRuntime {
    context: JSContext,
    /// Raw global context pointer — used for drainMicrotasks.
    raw_ctx: JSGlobalContextRef,
    /// Stored closures for registered functions — prevents memory leaks.
    /// `Box::into_raw()` pointers are reclaimed when the runtime drops.
    _closures: Vec<*mut Box<ClosureFn>>,
}

impl JscRuntime {
    pub fn new() -> Result<Self, JoltError> {
        // Create context group + global context manually so we can store the raw pointer.
        let group = unsafe { rusty_jsc_sys::JSContextGroupCreate() };
        let raw_ctx =
            unsafe { rusty_jsc_sys::JSGlobalContextCreateInGroup(group, std::ptr::null_mut()) };
        let context = JSContext::from(raw_ctx as _);
        // Release our retain — JSContext::from retains internally.
        unsafe {
            rusty_jsc_sys::JSGlobalContextRelease(raw_ctx);
            rusty_jsc_sys::JSContextGroupRelease(group);
        }
        Ok(Self {
            context,
            raw_ctx,
            _closures: Vec::new(),
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

    fn eval_async(&mut self, code: &str) -> JsResultFuture<'_> {
        // Wrap the code to detect promises: if the result is a Promise, attach a
        // .then()/.catch() to capture the resolved/rejected value, then drain microtasks.
        let wrapper = format!(
            r#"(function() {{
                var __result = {{ resolved: false, value: undefined, error: undefined }};
                var __val = (function() {{ return {code}; }})();
                if (__val && typeof __val === 'object' && typeof __val.then === 'function') {{
                    __val.then(
                        function(v) {{ __result.resolved = true; __result.value = v; }},
                        function(e) {{ __result.resolved = true; __result.error = e; }}
                    );
                    return __result;
                }}
                return {{ resolved: true, value: __val }};
            }})()"#
        );

        let raw_ctx = self.raw_ctx;

        Box::pin(async move {
            let result = self
                .context
                .evaluate_script(&wrapper, 1)
                .map_err(|e| self.jsc_err_to_jolt(e))?;

            // Drain microtasks to resolve .then()/.catch() callbacks
            drain_jsc_microtasks(raw_ctx);

            // Extract the result object
            let result_obj = result
                .to_object(&self.context)
                .map_err(|e| self.jsc_err_to_jolt(e))?;

            let resolved = result_obj
                .get_property(&self.context, "resolved")
                .to_bool(&self.context);

            if !resolved {
                return Err(JoltError::RuntimeError(
                    "Promise did not resolve (drainMicrotasks unavailable?)".to_owned(),
                ));
            }

            let error = result_obj.get_property(&self.context, "error");
            if !error.is_undefined(&self.context) {
                let msg = error
                    .to_string(&self.context)
                    .map(|s| s.to_string())
                    .unwrap_or_else(|_| "Promise rejected".to_owned());
                return Err(JoltError::EvalError {
                    message: msg,
                    stack: None,
                });
            }

            let value = result_obj.get_property(&self.context, "value");
            to_js_value(&self.context, &value)
        })
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
        let raw_ptr = register_function_impl(&mut self.context, name, f)?;
        self._closures.push(raw_ptr);
        Ok(())
    }

    fn eval_module(&mut self, code: &str, _module_name: &str) -> Result<JsValue, JoltError> {
        // JSC's C API doesn't expose module evaluation directly through rusty_jsc.
        // Evaluate as a regular script for now.
        self.eval(code)
    }
}

impl Drop for JscRuntime {
    fn drop(&mut self) {
        for ptr in self._closures.drain(..) {
            unsafe { drop(Box::from_raw(ptr)) };
        }
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
        let result = rt.eval("2.72").unwrap();
        assert_eq!(result, JsValue::Float(2.72));
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
        rt.set_global("greeting", JsValue::String("hello".to_owned()))
            .unwrap();
        let result = rt.eval("greeting.toUpperCase()").unwrap();
        assert_eq!(result, JsValue::String("HELLO".to_owned()));
    }

    #[test]
    fn test_call_function() {
        let mut rt = JscRuntime::new().unwrap();
        rt.eval("function add(a, b) { return a + b; }").unwrap();
        let result = rt
            .call_function("add", &[JsValue::Int(2), JsValue::Int(3)])
            .unwrap();
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
        rt.register_function("get_pi", |_args| Ok(JsValue::Float(2.72)))
            .unwrap();
        let result = rt.eval("get_pi()").unwrap();
        assert_eq!(result, JsValue::Float(2.72));
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
                assert!(entries
                    .iter()
                    .any(|e| e.key == "a" && e.value == JsValue::Int(1)));
                assert!(entries
                    .iter()
                    .any(|e| e.key == "b" && e.value == JsValue::String("two".to_owned())));
            }
            other => panic!("Expected object, got {other:?}"),
        }
    }

    // --- Additional tests ---

    #[test]
    fn test_register_function_replace() {
        let mut rt = JscRuntime::new().unwrap();
        rt.register_function("val", |_| Ok(JsValue::Int(1)))
            .unwrap();
        assert_eq!(rt.eval("val()").unwrap(), JsValue::Int(1));
        rt.register_function("val", |_| Ok(JsValue::Int(2)))
            .unwrap();
        assert_eq!(rt.eval("val()").unwrap(), JsValue::Int(2));
    }

    #[test]
    fn test_register_many_functions() {
        let mut rt = JscRuntime::new().unwrap();
        for i in 0..100 {
            let name = format!("fn_{i}");
            rt.register_function(&name, move |_| Ok(JsValue::Int(i)))
                .unwrap();
        }
        assert_eq!(rt.eval("fn_0()").unwrap(), JsValue::Int(0));
        assert_eq!(rt.eval("fn_99()").unwrap(), JsValue::Int(99));
    }

    #[test]
    fn test_call_function_not_found() {
        let mut rt = JscRuntime::new().unwrap();
        let result = rt.call_function("nonexistent", &[]);
        assert!(matches!(result, Err(JoltError::FunctionNotFound(_))));
    }

    #[test]
    fn test_eval_syntax_error() {
        let mut rt = JscRuntime::new().unwrap();
        let result = rt.eval("function {{{");
        assert!(matches!(result, Err(JoltError::EvalError { .. })));
    }

    #[test]
    fn test_nested_object() {
        let mut rt = JscRuntime::new().unwrap();
        let result = rt.eval("({a: {b: 1}})").unwrap();
        match result {
            JsValue::Object(outer) => {
                let inner = outer.iter().find(|e| e.key == "a").unwrap();
                match &inner.value {
                    JsValue::Object(entries) => {
                        assert!(entries
                            .iter()
                            .any(|e| e.key == "b" && e.value == JsValue::Int(1)));
                    }
                    other => panic!("Expected nested object, got {other:?}"),
                }
            }
            other => panic!("Expected object, got {other:?}"),
        }
    }

    #[test]
    fn test_large_array() {
        let mut rt = JscRuntime::new().unwrap();
        let result = rt.eval("Array.from({length: 1000}, (_, i) => i)").unwrap();
        match result {
            JsValue::Array(arr) => assert_eq!(arr.len(), 1000),
            other => panic!("Expected array, got {other:?}"),
        }
    }

    #[test]
    fn test_persistent_state_across_evals() {
        let mut rt = JscRuntime::new().unwrap();
        rt.eval("var counter = 0").unwrap();
        rt.eval("counter += 1").unwrap();
        rt.eval("counter += 1").unwrap();
        rt.eval("counter += 1").unwrap();
        let result = rt.eval("counter").unwrap();
        assert_eq!(result, JsValue::Int(3));
    }

    #[test]
    fn test_closure_captures_state() {
        let mut rt = JscRuntime::new().unwrap();
        rt.eval(
            r#"
            var state = { count: 0 };
            function increment() { state.count += 1; return state.count; }
        "#,
        )
        .unwrap();
        assert_eq!(rt.eval("increment()").unwrap(), JsValue::Int(1));
        assert_eq!(rt.eval("increment()").unwrap(), JsValue::Int(2));
        assert_eq!(rt.eval("increment()").unwrap(), JsValue::Int(3));
    }

    #[test]
    fn test_proxy_with_registered_functions() {
        let mut rt = JscRuntime::new().unwrap();

        use std::sync::{Arc, Mutex};
        let mutations: Arc<Mutex<Vec<(String, JsValue)>>> = Arc::new(Mutex::new(Vec::new()));
        let mutations_clone = mutations.clone();

        rt.register_function("__setter", move |args| {
            let key = args[0].as_str().unwrap_or("").to_owned();
            let value = args.get(1).cloned().unwrap_or(JsValue::Undefined);
            mutations_clone.lock().unwrap().push((key, value));
            Ok(JsValue::Bool(true))
        })
        .unwrap();

        rt.register_function("__getter", |args| {
            let key = args[0].as_str().unwrap_or("");
            match key {
                "count" => Ok(JsValue::Int(5)),
                _ => Ok(JsValue::Undefined),
            }
        })
        .unwrap();

        rt.eval(
            r#"
            var props = new Proxy({}, {
                get(target, key) { return __getter(key); },
                set(target, key, value) { return __setter(key, value); }
            });
        "#,
        )
        .unwrap();

        let result = rt.eval("props.count").unwrap();
        assert_eq!(result, JsValue::Int(5));

        rt.eval("props.count = 10").unwrap();
        let m = mutations.lock().unwrap();
        assert_eq!(m.len(), 1);
        assert_eq!(m[0].0, "count");
        assert_eq!(m[0].1, JsValue::Int(10));
    }

    #[test]
    fn test_iife_scope_with_eval() {
        let mut rt = JscRuntime::new().unwrap();

        rt.eval(
            r#"
            var __scope = (function() {
                var local_count = 0;
                return function(code) { return eval(code); };
            })();
        "#,
        )
        .unwrap();

        let result = rt.eval("__scope('local_count += 1')").unwrap();
        assert_eq!(result, JsValue::Int(1));
        let result = rt.eval("__scope('local_count += 1')").unwrap();
        assert_eq!(result, JsValue::Int(2));

        let result = rt.eval("typeof local_count");
        assert_eq!(result.unwrap(), JsValue::String("undefined".to_owned()));
    }

    #[test]
    fn test_cross_scope_closure() {
        let mut rt = JscRuntime::new().unwrap();

        rt.eval(
            r#"
            var shared_ctx = {};
            var __parent = (function() {
                var count = 0;
                shared_ctx.increment = function() { count += 1; return count; };
                return function(code) { return eval(code); };
            })();
            var __child = (function() {
                var ctx = shared_ctx;
                return function(code) { return eval(code); };
            })();
        "#,
        )
        .unwrap();

        let result = rt.eval("__child('ctx.increment()')").unwrap();
        assert_eq!(result, JsValue::Int(1));
        let result = rt.eval("__child('ctx.increment()')").unwrap();
        assert_eq!(result, JsValue::Int(2));

        let result = rt.eval("__parent('count')").unwrap();
        assert_eq!(result, JsValue::Int(2));
    }

    #[test]
    fn test_runtime_drop_frees_closures() {
        // Verify no crash when dropping a runtime with many registered functions
        for _ in 0..10 {
            let mut rt = JscRuntime::new().unwrap();
            for i in 0..50 {
                let name = format!("f_{i}");
                rt.register_function(&name, move |_| Ok(JsValue::Int(i)))
                    .unwrap();
            }
            // rt drops here — all closures should be freed
        }
    }

    #[tokio::test]
    async fn test_eval_async_promise() {
        let mut rt = JscRuntime::new().unwrap();
        let result = rt.eval_async("Promise.resolve(42)").await.unwrap();
        assert_eq!(result, JsValue::Int(42));
    }

    #[tokio::test]
    async fn test_eval_async_chained_promise() {
        let mut rt = JscRuntime::new().unwrap();
        let result = rt
            .eval_async("Promise.resolve(10).then(x => x * 2).then(x => x + 1)")
            .await
            .unwrap();
        assert_eq!(result, JsValue::Int(21));
    }

    #[tokio::test]
    async fn test_eval_async_non_promise() {
        let mut rt = JscRuntime::new().unwrap();
        let result = rt.eval_async("1 + 1").await.unwrap();
        assert_eq!(result, JsValue::Int(2));
    }

    #[tokio::test]
    async fn test_eval_async_rejected_promise() {
        let mut rt = JscRuntime::new().unwrap();
        let result = rt.eval_async("Promise.reject('boom')").await;
        assert!(result.is_err());
    }
}
