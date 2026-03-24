//! Core types and traits for the Jolt JavaScript runtime.
//!
//! This crate defines the [`JsRuntime`] trait that all Jolt backends implement,
//! along with shared types ([`JsValue`], [`JsEntry`], [`JoltError`]) used to
//! exchange data between Rust and JavaScript.
//!
//! # Usage
//!
//! Most users should depend on the [`jolt`](https://docs.rs/jolt) facade crate
//! rather than using `jolt_core` directly. Use this crate when you need the
//! trait or types without pulling in a specific backend.
//!
//! ```rust,ignore
//! use jolt_core::{JsRuntime, JsValue, JoltError};
//!
//! fn run_js(rt: &mut impl JsRuntime) -> Result<JsValue, JoltError> {
//!     rt.eval("1 + 1")
//! }
//! ```

mod error;
mod runtime;
mod value;

pub use error::JoltError;
pub use runtime::{JsResultFuture, JsRuntime};
pub use value::{JsEntry, JsValue};
