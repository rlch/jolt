/// Rust-powered JavaScript runtime for Flutter.
///
/// Jolt picks the best JS engine per platform — JavaScriptCore on Apple,
/// QuickJS on Android/Linux/Windows, and the host browser engine on web —
/// and exposes a single Dart API via `flutter_rust_bridge`.
///
/// ## Quick start
///
/// ```dart
/// import 'package:flutter_jolt/flutter_jolt.dart';
///
/// // Initialize once (typically in main)
/// await RustLib.init();
///
/// // Create a runtime
/// final rt = JoltRuntime();
///
/// // Evaluate JavaScript
/// final result = await rt.eval(code: '1 + 1');
///
/// // Globals
/// await rt.setGlobal(name: 'x', value: JsValue.int_(42));
///
/// // Call JS functions
/// await rt.eval(code: 'function add(a, b) { return a + b; }');
/// final sum = await rt.callFunction(
///   name: 'add',
///   args: [JsValue.int_(2), JsValue.int_(3)],
/// );
/// ```
///
/// ## Key types
///
/// - [JoltRuntime] — the JavaScript runtime instance.
/// - [JsValue] — values exchanged between Dart and JavaScript.
/// - [JsEntry] — a key-value pair in a [JsValue.object].
/// - [JoltError] — errors from evaluation, conversion, or runtime failures.
/// - [RustLib] — initialization entry point (call `RustLib.init()` once).
library flutter_jolt;

export 'src/rust/api/simple.dart';
export 'src/rust/frb_generated.dart' show RustLib;
