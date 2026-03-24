//! Rust-powered JavaScript runtime that selects the best engine per platform.
//!
//! `jolt` is a facade crate — it re-exports [`JsRuntime`], [`JsValue`], and
//! friends from [`jolt_core`], and aliases one backend as [`DefaultRuntime`]
//! based on `cfg` gates:
//!
//! | Target | Backend |
//! |---|---|
//! | iOS / macOS | [`jolt_jsc::JscRuntime`] (JavaScriptCore) |
//! | `wasm32` | [`jolt_web::WebRuntime`] (host browser JS) |
//! | Everything else | [`jolt_quickjs::QuickJsRuntime`] (QuickJS) |
//!
//! # Quick start
//!
//! ```rust,no_run
//! use jolt::{create_runtime, JsRuntime, JsValue};
//!
//! let mut rt = create_runtime().unwrap();
//! let result = rt.eval("1 + 1").unwrap();
//! assert_eq!(result, JsValue::Int(2));
//! ```

pub use jolt_core::{JoltError, JsEntry, JsRuntime, JsValue};

#[cfg(target_os = "ios")]
mod backend {
    pub use jolt_jsc::JscRuntime as DefaultRuntime;
}

#[cfg(target_os = "macos")]
mod backend {
    pub use jolt_jsc::JscRuntime as DefaultRuntime;
}

#[cfg(target_arch = "wasm32")]
mod backend {
    pub use jolt_web::WebRuntime as DefaultRuntime;
}

#[cfg(not(any(target_os = "ios", target_os = "macos", target_arch = "wasm32")))]
mod backend {
    pub use jolt_quickjs::QuickJsRuntime as DefaultRuntime;
}

/// The runtime implementation selected for the current compilation target.
pub use backend::DefaultRuntime;

/// Create a new JavaScript runtime using the platform-appropriate engine.
pub fn create_runtime() -> Result<DefaultRuntime, JoltError> {
    DefaultRuntime::new()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_facade_eval() {
        let mut rt = create_runtime().unwrap();
        let result = rt.eval("1 + 1").unwrap();
        assert_eq!(result, JsValue::Int(2));
    }

    #[test]
    fn test_facade_globals() {
        let mut rt = create_runtime().unwrap();
        rt.set_global("x", JsValue::Int(42)).unwrap();
        let result = rt.get_global("x").unwrap();
        assert_eq!(result, JsValue::Int(42));
    }

    #[test]
    fn test_facade_call_function() {
        let mut rt = create_runtime().unwrap();
        rt.eval("function greet(name) { return 'Hello, ' + name + '!'; }")
            .unwrap();
        let result = rt
            .call_function("greet", &[JsValue::from("World")])
            .unwrap();
        assert_eq!(result, JsValue::String("Hello, World!".to_owned()));
    }
}
