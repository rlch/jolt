# jolt_core

[![crates.io](https://img.shields.io/crates/v/jolt_core.svg)](https://crates.io/crates/jolt_core)
[![docs.rs](https://img.shields.io/docsrs/jolt_core)](https://docs.rs/jolt_core)

Core types and traits for the [Jolt](https://github.com/rlch/jolt) JavaScript runtime.

This crate provides:

- **`JsRuntime`** — the trait all Jolt backends implement
- **`JsValue`** — values exchanged between Rust and JavaScript
- **`JsEntry`** — key-value pairs in JS objects
- **`JoltError`** — error types for evaluation, conversion, and runtime failures

## Usage

Most users should depend on a backend crate ([`jolt_quickjs`](https://crates.io/crates/jolt_quickjs), [`jolt_jsc`](https://github.com/rlch/jolt/tree/main/crates/jsc), [`jolt_web`](https://crates.io/crates/jolt_web)) or the [`jolt`](https://github.com/rlch/jolt) facade. Use `jolt_core` directly when you need the trait or types without a specific engine.

```rust
use jolt_core::{JsRuntime, JsValue, JoltError};

fn run_js(rt: &mut impl JsRuntime) -> Result<JsValue, JoltError> {
    rt.eval("1 + 1")
}
```

## License

MIT
