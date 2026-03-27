# Jolt

Rust-powered JavaScript runtime. Uses the most idiomatic JS engine per platform. Rust crates are independent and usable without Flutter. The Flutter plugin lives in a separate repo: [rlch/flutter_jolt](https://github.com/rlch/flutter_jolt).

## Engine Matrix

- **iOS/macOS**: JavaScriptCore via `rusty_jsc` (native, zero bundle cost)
- **Android/Linux/Windows**: QuickJS via `rquickjs` (~1MB, no JIT)
- **Web/WASM**: Host JS via `js-sys`/`wasm-bindgen`

## Workspace Layout

- `crates/core/` — `JsRuntime` trait + types (`JsValue`, `JsResultFuture`, `JoltError`). No engine dependency.
- `crates/quickjs/` — QuickJS backend. Standalone — use directly in any Rust project.
- `crates/jsc/` — JavaScriptCore backend. Standalone — use directly on Apple platforms.
- `crates/web/` — WASM/browser backend. Standalone — use directly in WASM apps.
- `crates/jolt/` — Facade crate (cfg-gated re-export of correct backend per target)

## Build & Test

```bash
# Test all native Rust crates (use --test-threads=1 for JSC thread safety)
cargo test --workspace -- --test-threads=1

# WASM tests (requires wasm-pack + Node.js)
cd crates/web && wasm-pack test --node

# Individual crates
cargo test -p jolt_core
cargo test -p jolt_quickjs
cargo test -p jolt_jsc -- --test-threads=1
cargo test -p jolt_rs -- --test-threads=1
```

## Key Design Decisions

- JSC tests must run single-threaded (`--test-threads=1`) due to JSC's thread safety model
- `eval_async` returns `JsResultFuture` (`Pin<Box<dyn Future>>`) — async on all backends

## Memory Management

- **JSC**: `register_function()` uses `Box::into_raw()` for FFI trampoline pointers. Raw pointers stored in `JscRuntime._closures`, reclaimed via `Box::from_raw()` on `Drop`.
- **Web**: Registered function closures stored in `WebRuntime._closures_variadic`, drop with the runtime.
- **QuickJS**: Memory managed by `rquickjs` context lifecycle — no manual cleanup needed.

## Thread Safety

- All backends require exclusive `&mut self` access via the `JsRuntime` trait
- JSC is single-threaded — `unsafe impl Send` is safe under exclusive access but JSC contexts must not be shared across threads
- Web/WASM is inherently single-threaded

## Promise Resolution (eval_async)

- **QuickJS**: Uses `MaybePromise::finish()` which drives the internal job queue synchronously. Resolves on first poll.
- **JSC**: Uses `JSC::VM::drainMicrotasks()` via `dlsym` at runtime. `JSContextGetGroup()` (public C API) returns `VM*`, then the mangled C++ symbol `_ZN3JSC2VM15drainMicrotasksEv` is called to drain the microtask queue. Graceful fallback if symbol unavailable.
- **Web**: Uses `wasm_bindgen_futures::JsFuture` to properly await JS promises on the browser event loop.

## Known Limitations

- `eval_module` on JSC/Web falls back to `eval()` — no module semantics
