//! WASM/browser backend for the Jolt JavaScript runtime.
//!
//! Provides [`WebRuntime`], a [`JsRuntime`](jolt_core::JsRuntime)
//! implementation that delegates to the host browser's JavaScript engine
//! via [`js_sys`] and [`wasm_bindgen`]. Used when compiling to
//! `wasm32` targets.

mod convert;
mod runtime;

pub use runtime::WebRuntime;
