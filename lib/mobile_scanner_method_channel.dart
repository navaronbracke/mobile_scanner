import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'mobile_scanner_platform_interface.dart';

/// An implementation of [MobileScannerPlatform] that uses method channels.
class MethodChannelMobileScanner extends MobileScannerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('dev.steenbakker.mobile_scanner/scanner/method');

  /// The event channel that sends back scanned barcode events.
  @visibleForTesting
  final eventChannel = const EventChannel('dev.steenbakker.mobile_scanner/scanner/event');

  // TODO: implement platform interface methods
}
