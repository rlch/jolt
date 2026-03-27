# Jolt (JavaScript on lots of targets)

Rust-powered JavaScript runtime. Picks the best JS engine for each platform — use standalone in Rust, or with Flutter via [`flutter_jolt`](https://github.com/rlch/flutter_jolt).

[![CI](https://github.com/rlch/jolt/actions/workflows/ci.yml/badge.svg)](https://github.com/rlch/jolt/actions/workflows/ci.yml)
[![crates.io](https://img.shields.io/crates/v/jolt_rs.svg)](https://crates.io/crates/jolt_rs)
[![docs.rs](https://img.shields.io/docsrs/jolt_rs)](https://docs.rs/jolt_rs)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## Why

Flutter has no built-in JS engine. Existing packages either bundle a single engine everywhere (wasting binary size on Apple platforms that ship JSC for free) or only target one platform. Jolt gives you:

- **Zero-cost JS on Apple** -- JavaScriptCore is already on device
- **Tiny JS everywhere else** -- QuickJS adds ~1 MB, no JIT required
- **Native speed on web** -- delegates straight to the browser's JS engine via `wasm-bindgen`

One API, three engines, every platform.

## Engine matrix

| Platform | Engine | Crate | Notes |
|---|---|---|---|
| iOS / macOS | JavaScriptCore | [`rusty_jsc`](https://docs.rs/rusty_jsc) | Native framework, zero bundle cost |
| Android / Linux / Windows | QuickJS | [`rquickjs`](https://docs.rs/rquickjs) | ~1 MB, embeddable, no JIT |
| Web (WASM) | Host JS | [`js-sys`](https://docs.rs/js-sys) / [`wasm-bindgen`](https://docs.rs/wasm-bindgen) | Calls through to browser engine |

## Quick start

The Rust crates are independent and can be used outside Flutter. Pick the backend for your target or use the `jolt` facade crate which selects automatically:

```rust
use jolt::{create_runtime, JsRuntime, JsValue};

let mut rt = create_runtime().unwrap();

// Evaluate JS
let result = rt.eval("1 + 1").unwrap();
assert_eq!(result, JsValue::Int(2));

// Globals
rt.set_global("name", JsValue::from("world")).unwrap();
let greeting = rt.eval("`Hello, ${name}!`").unwrap();

// Call functions defined in JS
rt.eval("function add(a, b) { return a + b; }").unwrap();
let sum = rt.call_function("add", &[JsValue::Int(2), JsValue::Int(3)]).unwrap();

// Register Rust functions callable from JS
rt.register_function("double", |args| {
    let n = args[0].as_i64().unwrap();
    Ok(JsValue::Int(n * 2))
}).unwrap();
let doubled = rt.eval("double(21)").unwrap();
```

Or use a specific backend directly:

```rust
// QuickJS — Android, Linux, Windows, or anywhere
use jolt_quickjs::QuickJsRuntime;
use jolt_core::{JsRuntime, JsValue};

let mut rt = QuickJsRuntime::new().unwrap();
let result = rt.eval("1 + 1").unwrap();

// JavaScriptCore — macOS, iOS
use jolt_jsc::JscRuntime;
let mut rt = JscRuntime::new().unwrap();
let result = rt.eval("1 + 1").unwrap();
```

For Flutter/Dart usage, see [`flutter_jolt`](https://github.com/rlch/flutter_jolt).

## Architecture

```
┌──────────────────────────────────────────────┐
│  jolt_rs (facade crate)                      │
│  cfg-gates the correct backend:              │
│    ios/macos  → jolt_jsc                     │
│    wasm32     → jolt_web                     │
│    otherwise  → jolt_quickjs                 │
├──────────────────────────────────────────────┤
│  jolt_core                                   │
│  JsRuntime trait + JsValue / JoltError types │
└──────────────────────────────────────────────┘
```

### Crates

| Crate | Use case | Dependency |
|---|---|---|
| `jolt_core` | `JsRuntime` trait, `JsValue`, `JoltError` | None (pure types) |
| `jolt_quickjs` | Embed QuickJS in any Rust app | `rquickjs` |
| `jolt_jsc` | Use JavaScriptCore on Apple platforms | `rusty_jsc` |
| `jolt_web` | Use host JS engine in WASM apps | `wasm-bindgen` |
| `jolt_rs` | Auto-select backend per target | One of the above |

### Workspace layout

```
crates/
  core/     — JsRuntime trait, JsValue, JoltError
  quickjs/  — QuickJS backend
  jsc/      — JavaScriptCore backend
  web/      — WASM/browser backend
  jolt/     — Facade (re-exports correct backend per target)
```

## Building & testing

Prerequisites: Rust toolchain, [`just`](https://github.com/casey/just) (optional).

```bash
# Run all native Rust tests (QuickJS + JSC + facade)
cargo test --workspace -- --test-threads=1

# Run WASM tests (requires wasm-pack + Node.js)
cd crates/web && wasm-pack test --node

# Individual crates
cargo test -p jolt_quickjs
cargo test -p jolt_jsc -- --test-threads=1
cargo test -p jolt_core
```

> JSC tests must run single-threaded (`--test-threads=1`) due to JavaScriptCore's threading model.

## Status

| Feature | QuickJS | JSC | Web |
|---|---|---|---|
| `eval` | Yes | Yes | Yes |
| `eval_async` (promises) | Yes | Yes (via drainMicrotasks) | Yes (via JsFuture) |
| `call_function` | Yes | Yes | Yes |
| `set_global` / `get_global` | Yes | Yes | Yes |
| `register_function` | Yes | Yes | Yes |
| `eval_module` | Yes | Falls back to eval | Falls back to eval |
| Tests | 26 | 30 | 15 (wasm-pack) |

Current limitations:

- `eval_module` on JSC/Web falls back to `eval()` (no module semantics)

## Documentation

- **Rust API docs**: [docs.rs/jolt_rs](https://docs.rs/jolt_rs) (facade) | [docs.rs/jolt_core](https://docs.rs/jolt_core) (trait & types)
- **Backend docs**: [jolt_quickjs](https://docs.rs/jolt_quickjs) | [jolt_jsc](https://docs.rs/jolt_jsc) | [jolt_web](https://docs.rs/jolt_web)
- **Flutter plugin**: [flutter_jolt](https://github.com/rlch/flutter_jolt) | [pub.dev](https://pub.dev/packages/flutter_jolt)

## License

MIT
