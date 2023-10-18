import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/src/method_channel/mobile_scanner_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelMobileScanner platform = MethodChannelMobileScanner();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      platform.methodChannel,
      (MethodCall methodCall) async {
        // TODO: fix the mock method call handler
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      platform.methodChannel,
      null,
    );
  });

  // TODO: write tests using `test()` and `expect()` that verify the behavior of the channels
}
