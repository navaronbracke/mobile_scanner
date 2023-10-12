// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://docs.flutter.dev/cookbook/testing/integration/introduction

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('plugin integration tests', () {
    MobileScanner plugin;

    setUp(() {
      plugin = MobileScanner();
    });

    // TODO: write integration tests using `testWidgets`
    // See https://docs.flutter.dev/testing/integration-tests
  });
}
