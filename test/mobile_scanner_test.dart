import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/src/method_channel/mobile_scanner_method_channel.dart';
import 'package:mobile_scanner/src/mobile_scanner_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMobileScannerPlatform with MockPlatformInterfaceMixin implements MobileScannerPlatform {
  @override
  Future<void> dispose() => Future.value();

  @override
  Future<void> updateScanWindow(Rect? window) => Future.value();
}

// TODO: test default instance for web

void main() {
  final MobileScannerPlatform initialPlatform = MobileScannerPlatform.instance;

  test('$MethodChannelMobileScanner is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMobileScanner>());
  });

  // TODO: this test is broken anyway
  /*test('getPlatformVersion', () async {
    MobileScanner mobileScannerPlugin = MobileScanner();
    MockMobileScannerPlatform fakePlatform = MockMobileScannerPlatform();
    MobileScannerPlatform.instance = fakePlatform;

    expect(await mobileScannerPlugin.getPlatformVersion(), '42');
  });*/
}
