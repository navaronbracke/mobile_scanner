import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mobile_scanner/mobile_scanner_platform_interface.dart';
import 'package:mobile_scanner/mobile_scanner_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMobileScannerPlatform with MockPlatformInterfaceMixin implements MobileScannerPlatform {
  // TODO: implement platform interface methods for the mock
}

// TODO: test default instance for web

void main() {
  final MobileScannerPlatform initialPlatform = MobileScannerPlatform.instance;

  test('$MethodChannelMobileScanner is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMobileScanner>());
  });

  // TODO: this test is broken anyway
  test('getPlatformVersion', () async {
    MobileScanner mobileScannerPlugin = MobileScanner();
    MockMobileScannerPlatform fakePlatform = MockMobileScannerPlatform();
    MobileScannerPlatform.instance = fakePlatform;

    expect(await mobileScannerPlugin.getPlatformVersion(), '42');
  });
}
