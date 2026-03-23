use jolt::{create_runtime, JsRuntime};
use std::sync::Mutex;

// Re-export core types so they're accessible from this crate
pub use jolt_core::{JsEntry, JsValue, JoltError};

// Mirror definitions tell FRB how to generate translatable Dart types
// for types defined in external crates. The structure must match exactly.

#[flutter_rust_bridge::frb(mirror(JsValue))]
pub enum _JsValue {
    Undefined,
    Null,
    Bool(bool),
    Int(i64),
    Float(f64),
    String(String),
    Array(Vec<JsValue>),
    Object(Vec<JsEntry>),
    Bytes(Vec<u8>),
}

#[flutter_rust_bridge::frb(mirror(JsEntry))]
pub struct _JsEntry {
    pub key: String,
    pub value: JsValue,
}

#[flutter_rust_bridge::frb(mirror(JoltError))]
pub enum _JoltError {
    EvalError {
        message: String,
        stack: Option<String>,
    },
    ConversionError(String),
    RuntimeError(String),
    FunctionNotFound(String),
}

pub struct JoltRuntime {
    inner: Mutex<jolt::DefaultRuntime>,
}

#[flutter_rust_bridge::frb]
impl JoltRuntime {
    #[flutter_rust_bridge::frb(sync)]
    pub fn new() -> Result<JoltRuntime, JoltError> {
        Ok(JoltRuntime {
            inner: Mutex::new(create_runtime()?),
        })
    }

    pub fn eval(&self, code: String) -> Result<JsValue, JoltError> {
        self.inner.lock().unwrap().eval(&code)
    }

    pub fn eval_async(&self, code: String) -> Result<JsValue, JoltError> {
        self.inner.lock().unwrap().eval_async(&code)
    }

    pub fn call_function(
        &self,
        name: String,
        args: Vec<JsValue>,
    ) -> Result<JsValue, JoltError> {
        self.inner.lock().unwrap().call_function(&name, &args)
    }

    pub fn set_global(&self, name: String, value: JsValue) -> Result<(), JoltError> {
        self.inner.lock().unwrap().set_global(&name, value)
    }

    pub fn get_global(&self, name: String) -> Result<JsValue, JoltError> {
        self.inner.lock().unwrap().get_global(&name)
    }
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}
