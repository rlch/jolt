import 'package:flutter/material.dart';
import 'package:flutter_jolt/flutter_jolt.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jolt Example',
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final JoltRuntime _runtime;
  final List<_ShowcaseResult> _results = [];
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _runtime = JoltRuntime();
  }

  Future<void> _runShowcases() async {
    setState(() {
      _results.clear();
      _running = true;
    });

    final showcases = <_Showcase>[
      _Showcase('Basic Arithmetic', '2 + 2'),
      _Showcase('String Operations', '"hello".toUpperCase() + " WORLD"'),
      _Showcase('Array Methods', '[1,2,3].map(x => x * x).join(", ")'),
      _Showcase('JSON Round-trip',
          'JSON.stringify({name: "Jolt", version: 1, platforms: ["iOS","Android","macOS"]})'),
      _Showcase('Closures & IIFE',
          '(() => { let sum = 0; for (let i = 1; i <= 100; i++) sum += i; return sum; })()'),
      _Showcase('RegExp', '"2026-03-12".replace(/(\\d{4})-(\\d{2})-(\\d{2})/, "\$3/\$2/\$1")'),
      _Showcase('Error Handling',
          'try { undefined.property } catch(e) { "Caught: " + e.message }'),
      _Showcase('Destructuring & Spread',
          '(() => { const a = [1,2,3]; const b = [0, ...a, 4]; return b.length; })()'),
      _Showcase('Template Literals',
          '(() => { const lang = "JavaScript"; return `Running \${lang} from Dart via Rust`; })()'),
      _Showcase('Math', 'Math.round(Math.PI * 1000) / 1000'),
    ];

    for (final s in showcases) {
      try {
        final value = await _runtime.eval(code: s.code);
        setState(() => _results.add(_ShowcaseResult(
              title: s.title,
              code: s.code,
              result: _formatJsValue(value),
            )));
      } catch (e) {
        setState(() => _results.add(_ShowcaseResult(
              title: s.title,
              code: s.code,
              result: 'Error: $e',
              isError: true,
            )));
      }
    }

    // Globals showcase
    try {
      await _runtime.setGlobal(
        name: 'greeting',
        value: const JsValue.string('Hello from Dart'),
      );
      final value = await _runtime.eval(code: 'greeting + "!"');
      setState(() => _results.add(_ShowcaseResult(
            title: 'Dart → JS Globals',
            code: 'setGlobal("greeting", "Hello from Dart") → eval(\'greeting + "!"\')',
            result: _formatJsValue(value),
          )));
    } catch (e) {
      setState(() => _results.add(_ShowcaseResult(
            title: 'Dart → JS Globals',
            code: 'setGlobal + eval',
            result: 'Error: $e',
            isError: true,
          )));
    }

    // callFunction showcase
    try {
      await _runtime.eval(
          code: 'function add(a, b) { return a + b; }');
      final value = await _runtime.callFunction(
        name: 'add',
        args: [const JsValue.int(17), const JsValue.int(25)],
      );
      setState(() => _results.add(_ShowcaseResult(
            title: 'Call JS Function',
            code: 'add(17, 25)',
            result: _formatJsValue(value),
          )));
    } catch (e) {
      setState(() => _results.add(_ShowcaseResult(
            title: 'Call JS Function',
            code: 'add(17, 25)',
            result: 'Error: $e',
            isError: true,
          )));
    }

    setState(() => _running = false);
  }

  String _formatJsValue(JsValue value) {
    return switch (value) {
      JsValue_Undefined() => 'undefined',
      JsValue_Null() => 'null',
      JsValue_Bool(:final field0) => '$field0',
      JsValue_Int(:final field0) => '$field0',
      JsValue_Float(:final field0) => '$field0',
      JsValue_String(:final field0) => field0,
      JsValue_Array(:final field0) =>
        '[${field0.map(_formatJsValue).join(', ')}]',
      JsValue_Object(:final field0) =>
        '{${field0.map((e) => '${e.key}: ${_formatJsValue(e.value)}').join(', ')}}',
      JsValue_Bytes(:final field0) => 'Uint8List(${field0.length})',
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jolt'),
        actions: [
          if (_running)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: _results.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.code, size: 64, color: theme.colorScheme.primary),
                  const SizedBox(height: 16),
                  Text('JavaScript runtime for Flutter',
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Powered by Rust',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: theme.colorScheme.outline)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _results.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final r = _results[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                                color: theme.colorScheme.primary)),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(r.code,
                              style: theme.textTheme.bodySmall?.copyWith(
                                  fontFamily: 'monospace',
                                  color: theme.colorScheme.onSurfaceVariant)),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              r.isError ? Icons.error_outline : Icons.arrow_forward,
                              size: 16,
                              color: r.isError
                                  ? theme.colorScheme.error
                                  : theme.colorScheme.tertiary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                r.result,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.w600,
                                  color: r.isError
                                      ? theme.colorScheme.error
                                      : theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _running ? null : _runShowcases,
        icon: const Icon(Icons.play_arrow),
        label: const Text('Run'),
      ),
    );
  }
}

class _Showcase {
  final String title;
  final String code;
  const _Showcase(this.title, this.code);
}

class _ShowcaseResult {
  final String title;
  final String code;
  final String result;
  final bool isError;
  const _ShowcaseResult({
    required this.title,
    required this.code,
    required this.result,
    this.isError = false,
  });
}
