//! QuickJS backend for the Jolt JavaScript runtime.
//!
//! Provides [`QuickJsRuntime`], a [`JsRuntime`](jolt_core::JsRuntime)
//! implementation backed by [QuickJS](https://bellard.org/quickjs/) via
//! the [`rquickjs`] crate. Suitable for Android, Linux, Windows, and any
//! other target where a small (~1 MB) embeddable JS engine is needed.
//!
//! # Usage
//!
//! ```rust
//! use jolt_quickjs::QuickJsRuntime;
//! use jolt_core::{JsRuntime, JsValue};
//!
//! let mut rt = QuickJsRuntime::new().unwrap();
//! let result = rt.eval("2 + 2").unwrap();
//! assert_eq!(result, JsValue::Int(4));
//! ```

mod convert;
mod runtime;

pub use runtime::QuickJsRuntime;
