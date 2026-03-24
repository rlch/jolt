use std::future::Future;
use std::pin::Pin;

use crate::{JoltError, JsValue};

/// A boxed future returning a Result — used for async runtime methods.
pub type JsResultFuture<'a> = Pin<Box<dyn Future<Output = Result<JsValue, JoltError>> + 'a>>;

/// A JavaScript runtime capable of evaluating code and exchanging values with Rust.
///
/// Each backend ([`QuickJS`](https://docs.rs/jolt_quickjs),
/// [`JSC`](https://docs.rs/jolt_jsc), [`Web`](https://docs.rs/jolt_web))
/// implements this trait. The [`jolt`](https://docs.rs/jolt) facade crate
/// re-exports the correct implementation as `DefaultRuntime` based on the
/// compilation target.
pub trait JsRuntime: Send {
    /// Evaluate a JS expression/script.
    fn eval(&mut self, code: &str) -> Result<JsValue, JoltError>;

    /// Evaluate JS code and await the result if it's a Promise.
    /// Returns the resolved value for promises, or the direct result for non-promise values.
    fn eval_async(&mut self, code: &str) -> JsResultFuture<'_>;

    /// Call a global function by name.
    fn call_function(&mut self, name: &str, args: &[JsValue]) -> Result<JsValue, JoltError>;

    /// Set a value on the global object.
    fn set_global(&mut self, name: &str, value: JsValue) -> Result<(), JoltError>;

    /// Get a value from the global object.
    fn get_global(&mut self, name: &str) -> Result<JsValue, JoltError>;

    /// Register a Rust callback callable from JS.
    fn register_function<F>(&mut self, name: &str, f: F) -> Result<(), JoltError>
    where
        F: Fn(Vec<JsValue>) -> Result<JsValue, JoltError> + Send + 'static;

    /// Evaluate an ES module.
    fn eval_module(&mut self, code: &str, module_name: &str) -> Result<JsValue, JoltError>;
}
