# jolt_web

[![crates.io](https://img.shields.io/crates/v/jolt_web.svg)](https://crates.io/crates/jolt_web)
[![docs.rs](https://img.shields.io/docsrs/jolt_web)](https://docs.rs/jolt_web)

WASM/browser backend for the [Jolt](https://github.com/rlch/jolt) JavaScript runtime.

Delegates to the host browser's JavaScript engine via [`js-sys`](https://docs.rs/js-sys) and [`wasm-bindgen`](https://docs.rs/wasm-bindgen). Zero bundle overhead — just calls through to the JS engine already running in the browser.

## Platform

Only compiles for `wasm32` targets. Used automatically by the `jolt` facade crate when targeting web.

## License

MIT
