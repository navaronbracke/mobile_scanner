import 'dart:ui';

import 'package:mobile_scanner/mobile_scanner.dart';

class MobileScannerHtmlViewConfiguration implements MobileScannerViewConfiguration {
  const MobileScannerHtmlViewConfiguration(
    this._domElementId,
    this.hasTorch,
    this.size,
  );

  /// The id of the DOM video element that represents the camera view.
  final String _domElementId;

  @override
  final bool hasTorch;

  @override
  final Size size;
}
