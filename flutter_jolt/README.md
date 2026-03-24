# flutter_jolt

[![pub.dev](https://img.shields.io/pub/v/flutter_jolt.svg)](https://pub.dev/packages/flutter_jolt)
[![CI](https://github.com/rlch/jolt/actions/workflows/ci.yml/badge.svg)](https://github.com/rlch/jolt/actions/workflows/ci.yml)

Flutter plugin for [Jolt](https://github.com/rlch/jolt) — a Rust-powered JavaScript runtime that picks the best engine per platform.

| Platform | Engine | Bundle cost |
|---|---|---|
| iOS / macOS | JavaScriptCore | 0 (system framework) |
| Android / Linux / Windows | QuickJS | ~1 MB |
| Web | Host browser JS | 0 |

## Usage

```dart
import 'package:flutter_jolt/flutter_jolt.dart';

// Initialize once (in main)
await RustLib.init();

// Create a runtime
final rt = JoltRuntime();

// Evaluate JavaScript
final result = await rt.eval(code: '1 + 1');

// Globals
await rt.setGlobal(name: 'x', value: JsValue.int_(42));
final x = await rt.getGlobal(name: 'x');

// Call JS functions
await rt.eval(code: 'function greet(n) { return "Hello, " + n; }');
final greeting = await rt.callFunction(
  name: 'greet',
  args: [JsValue.string('Flutter')],
);
```

## Installation

```yaml
dependencies:
  flutter_jolt: ^0.1.0
```

Requires Rust toolchain for native compilation. The plugin uses [Cargokit](https://github.com/aspect-build/cargokit) to build Rust code automatically during `flutter build` / `flutter run`.

## License

MIT — see [LICENSE](https://github.com/rlch/jolt/blob/main/LICENSE).
