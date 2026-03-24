//! JavaScriptCore backend for the Jolt JavaScript runtime.
//!
//! Provides [`JscRuntime`], a [`JsRuntime`](jolt_core::JsRuntime)
//! implementation that uses Apple's JavaScriptCore framework via the
//! [`rusty_jsc`] crate. Zero additional bundle size on iOS and macOS
//! since JSC ships as a system framework.
//!
//! # Platform requirements
//!
//! This crate only compiles on macOS and iOS. Tests must run
//! single-threaded (`--test-threads=1`) due to JSC's threading model.

mod convert;
mod runtime;

pub use runtime::JscRuntime;
