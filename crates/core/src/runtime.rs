use crate::{JoltError, JsValue};

pub trait JsRuntime: Send {
    /// Evaluate a JS expression/script.
    fn eval(&mut self, code: &str) -> Result<JsValue, JoltError>;

    /// Evaluate and await a Promise (resolved value).
    fn eval_async(&mut self, code: &str) -> Result<JsValue, JoltError>;

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
