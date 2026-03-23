import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jolt/flutter_jolt.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async => await RustLib.init());
  test('Can eval JS', () async {
    final runtime = JoltRuntime();
    final result = await runtime.eval(code: '1 + 1');
    expect(result, isA<JsValue>());
  });
}
