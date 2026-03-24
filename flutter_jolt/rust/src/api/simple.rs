use flutter_rust_bridge::DartFnFuture;
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

impl JoltRuntime {
    fn lock(&self) -> Result<std::sync::MutexGuard<'_, jolt::DefaultRuntime>, JoltError> {
        self.inner
            .lock()
            .map_err(|_| JoltError::RuntimeError("Runtime lock poisoned".to_owned()))
    }
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
        self.lock()?.eval(&code)
    }

    pub fn eval_async(&self, code: String) -> Result<JsValue, JoltError> {
        let mut guard = self.lock()?;
        let future = guard.eval_async(&code);
        // FRB handles the Dart async boundary. The future resolves synchronously on
        // QuickJS/JSC (job queue driven inline). On WASM this would need spawn_local,
        // but the FRB bridge isn't used on WASM (Dart calls JS directly).
        futures::executor::block_on(future)
    }

    pub fn call_function(
        &self,
        name: String,
        args: Vec<JsValue>,
    ) -> Result<JsValue, JoltError> {
        self.lock()?.call_function(&name, &args)
    }

    pub fn set_global(&self, name: String, value: JsValue) -> Result<(), JoltError> {
        self.lock()?.set_global(&name, value)
    }

    pub fn get_global(&self, name: String) -> Result<JsValue, JoltError> {
        self.lock()?.get_global(&name)
    }

    pub fn register_function(
        &self,
        name: String,
        callback: impl Fn(Vec<JsValue>) -> DartFnFuture<JsValue> + Send + 'static,
    ) -> Result<(), JoltError> {
        self.lock()?.register_function(&name, move |args| {
            // DartFnFuture is async — block_on to bridge to the sync register_function API.
            // This is safe because FRB dispatches to the platform thread.
            let result = futures::executor::block_on(callback(args));
            Ok(result)
        })
    }
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}
