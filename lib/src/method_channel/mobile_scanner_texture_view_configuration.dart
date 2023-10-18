import 'dart:ui';

import 'package:mobile_scanner/mobile_scanner.dart';

class MobileScannerTextureViewConfiguration implements MobileScannerViewConfiguration {
  const MobileScannerTextureViewConfiguration(
    this._textureId,
    this.hasTorch,
    this.size,
  );

  /// The id of the texture that represents the camera view.
  final int _textureId;

  @override
  final bool hasTorch;

  @override
  final Size size;
}
