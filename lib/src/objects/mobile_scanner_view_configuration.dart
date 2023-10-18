import 'dart:ui';

/// The view configuration for a mobile scanner that has been started.
abstract class MobileScannerViewConfiguration {
  /// Whether the initially active camera has a flashlight.
  bool get hasTorch;

  /// The size of the camera output.
  Size get size;
}
