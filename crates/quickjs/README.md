# jolt_quickjs

[![crates.io](https://img.shields.io/crates/v/jolt_quickjs.svg)](https://crates.io/crates/jolt_quickjs)
[![docs.rs](https://img.shields.io/docsrs/jolt_quickjs)](https://docs.rs/jolt_quickjs)

QuickJS backend for the [Jolt](https://github.com/rlch/jolt) JavaScript runtime.

Uses [QuickJS](https://bellard.org/quickjs/) via the [`rquickjs`](https://docs.rs/rquickjs) crate. Adds ~1 MB to your binary with no JIT — suitable for Android, Linux, Windows, and any other non-Apple, non-WASM target.

## Usage

```rust
use jolt_quickjs::QuickJsRuntime;
use jolt_core::{JsRuntime, JsValue};

let mut rt = QuickJsRuntime::new().unwrap();

let result = rt.eval("2 + 2").unwrap();
assert_eq!(result, JsValue::Int(4));

rt.set_global("name", JsValue::from("world")).unwrap();
let greeting = rt.eval("`Hello, ${name}!`").unwrap();

rt.register_function("double", |args| {
    Ok(JsValue::Int(args[0].as_i64().unwrap() * 2))
}).unwrap();
```

## License

MIT
