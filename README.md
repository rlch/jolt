# Jolt (JavaScript on lot's of targets)

Rust-powered JavaScript runtime for Flutter. Picks the best JS engine for each platform and bridges it to Dart via [`flutter_rust_bridge`](https://github.com/aspect-build/flutter_rust_bridge).

[![CI](https://github.com/rlch/jolt/actions/workflows/ci.yml/badge.svg)](https://github.com/rlch/jolt/actions/workflows/ci.yml)
[![crates.io](https://img.shields.io/crates/v/jolt_rs.svg)](https://crates.io/crates/jolt_rs)
[![docs.rs](https://img.shields.io/docsrs/jolt_rs)](https://docs.rs/jolt_rs)
[![pub.dev](https://img.shields.io/pub/v/flutter_jolt.svg)](https://pub.dev/packages/flutter_jolt)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## Why

Flutter has no built-in JS engine. Existing packages either bundle a single engine everywhere (wasting binary size on Apple platforms that ship JSC for free) or only target one platform. Jolt gives you:

- **Zero-cost JS on Apple** -- JavaScriptCore is already on device
- **Tiny JS everywhere else** -- QuickJS adds ~1 MB, no JIT required
- **Native speed on web** -- delegates straight to the browser's JS engine via `wasm-bindgen`

One Dart API, three engines, every Flutter platform.

## Engine matrix

| Platform | Engine | Crate | Notes |
|---|---|---|---|
| iOS / macOS | JavaScriptCore | [`rusty_jsc`](https://docs.rs/rusty_jsc) | Native framework, zero bundle cost |
| Android / Linux / Windows | QuickJS | [`rquickjs`](https://docs.rs/rquickjs) | ~1 MB, embeddable, no JIT |
| Web (WASM) | Host JS | [`js-sys`](https://docs.rs/js-sys) / [`wasm-bindgen`](https://docs.rs/wasm-bindgen) | Calls through to browser engine |

## Quick start

### Rust (standalone)

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

### Flutter (Dart)

```dart
import 'package:flutter_jolt/flutter_jolt.dart';

// Initialize once
await RustLib.init();

// Create a runtime
final rt = JoltRuntime();

// Evaluate JS
final result = await rt.eval(code: '1 + 1');

// Work with globals
await rt.setGlobal(name: 'x', value: JsValue.int_(42));
final x = await rt.getGlobal(name: 'x');

// Call JS functions
await rt.eval(code: 'function greet(name) { return "Hello, " + name; }');
final greeting = await rt.callFunction(
  name: 'greet',
  args: [JsValue.string('Flutter')],
);

// Register Dart functions callable from JS
await rt.registerFunction(
  name: 'double',
  callback: (args) => JsValue.int_(args[0].int_ * 2),
);
final doubled = await rt.eval(code: 'double(21)');
```

## Architecture

```
┌──────────────────────────────────────────────┐
│  flutter_jolt (Dart plugin)                  │
│  └─ rust/ (FRB bridge crate)                 │
│       └─ JoltRuntime ─► Mutex<DefaultRuntime>│
├──────────────────────────────────────────────┤
│  jolt (facade crate)                         │
│  cfg-gates the correct backend:              │
│    ios/macos  → jolt_jsc                     │
│    wasm32     → jolt_web                     │
│    otherwise  → jolt_quickjs                 │
├──────────────────────────────────────────────┤
│  jolt_core                                   │
│  JsRuntime trait + JsValue / JoltError types │
└──────────────────────────────────────────────┘
```

### Standalone Rust usage

Each crate is independent — use them without Flutter:

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
flutter_jolt/
  rust/     — FRB bridge crate
  lib/      — Generated Dart bindings
  example/  — Flutter demo app
```

## Building & testing

Prerequisites: Rust toolchain, Flutter SDK, [`just`](https://github.com/casey/just) (optional).

```bash
# Run all native Rust tests (QuickJS + JSC + facade)
cargo test --workspace -- --test-threads=1

# Run WASM tests (requires wasm-pack + Node.js)
cd crates/web && wasm-pack test --node

# Individual crates
cargo test -p jolt_quickjs
cargo test -p jolt_jsc -- --test-threads=1
cargo test -p jolt_core

# Regenerate Flutter bindings
cd flutter_jolt && flutter_rust_bridge_codegen generate

# Run the Flutter example app
cd flutter_jolt/example && flutter run
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
- FRB 2.11.1 generates a `wasmBindgenName` parameter that must be stripped after codegen (`just frb` handles this)

## Documentation

- **Rust API docs**: [docs.rs/jolt_rs](https://docs.rs/jolt_rs) (facade) | [docs.rs/jolt_core](https://docs.rs/jolt_core) (trait & types)
- **Dart API docs**: [pub.dev/documentation/flutter_jolt](https://pub.dev/documentation/flutter_jolt/latest/)
- **Backend docs**: [jolt_quickjs](https://docs.rs/jolt_quickjs) | [jolt_jsc](https://docs.rs/jolt_jsc) | [jolt_web](https://docs.rs/jolt_web)

## License

MIT
