import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:mobile_scanner/src/mobile_scanner_platform_interface.dart';

/// A web implementation of the MobileScannerPlatform of the MobileScanner plugin.
class MobileScannerWeb extends MobileScannerPlatform {
  /// Constructs a [MobileScannerWeb] instance.
  MobileScannerWeb();

  static void registerWith(Registrar registrar) {
    MobileScannerPlatform.instance = MobileScannerWeb();
  }

  // TODO: implement platform interface methods

  // TODO: provide a method specific to the web impl to set the type of scanning library to use
  // See platform specific options in webview package for example
  // - this should provide a JSQr and ZXing option
}
