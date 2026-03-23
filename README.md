# Jolt

Rust-powered JavaScript runtime for Flutter. Picks the best JS engine for each platform and bridges it to Dart via [`flutter_rust_bridge`](https://github.com/aspect-build/rules_swc).

## Why

Flutter has no built-in JS engine. Existing packages either bundle a single engine everywhere (wasting binary size on Apple platforms that ship JSC for free) or only target one platform. Jolt gives you:

- **Zero-cost JS on Apple** -- JavaScriptCore is already on device
- **Tiny JS everywhere else** -- QuickJS adds ~1 MB, no JIT required
- **Native speed on web** -- delegates straight to the browser's JS engine via `wasm-bindgen`

One Dart API, three engines, every Flutter platform.

## Engine matrix

| Platform | Engine | Crate | Notes |
|---|---|---|---|
| iOS / macOS | JavaScriptCore | [`rusty_jsc`](https://github.com/nicbarker/JavaScriptCore-sys) | Native framework, zero bundle cost |
| Android / Linux / Windows | QuickJS | [`rquickjs`](https://github.com/nicbarker/JavaScriptCore-sys) | ~1 MB, embeddable, no JIT |
| Web (WASM) | Host JS | [`js-sys`](https://docs.rs/js-sys) / [`wasm-bindgen`](https://docs.rs/wasm-bindgen) | Calls through to browser engine |

## Quick start

### Rust (standalone)

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

## Building

Prerequisites: Rust toolchain, Flutter SDK, [`just`](https://github.com/casey/just) (optional).

```bash
# Run all Rust tests
just test
# or: cargo test --workspace -- --test-threads=1

# Regenerate Flutter bindings
just frb

# Run the example app
just run          # macOS
just run-web      # Chrome (run `just build-web` first)
just run-device <id>
```

> JSC tests must run single-threaded (`--test-threads=1`) due to JavaScriptCore's threading model.

## Status

This is an early-stage project. Current limitations:

- `register_function` is not yet implemented for the JSC backend (requires unsafe FFI trampoline)
- `eval_async` and `eval_module` have partial implementations on JSC and WASM backends
- FRB 2.11.1 generates a `wasmBindgenName` parameter that must be stripped after codegen (`just frb` handles this)

## License

MIT
