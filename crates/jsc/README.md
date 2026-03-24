# jolt_jsc

JavaScriptCore backend for the [Jolt](https://github.com/rlch/jolt) JavaScript runtime.

Uses Apple's JavaScriptCore framework via [`rusty_jsc`](https://docs.rs/rusty_jsc). Zero additional bundle size on iOS and macOS since JSC ships as a system framework.

## Platform

Only compiles on macOS and iOS. Tests must run single-threaded (`--test-threads=1`) due to JSC's threading model.

> **Note**: This crate is not published to crates.io because it cannot be verified on Linux CI. It is used internally by the `jolt` facade and the `flutter_jolt` Flutter plugin.

## License

MIT
