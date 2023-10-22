import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mobile_scanner/src/enums/barcode_format.dart';
import 'package:mobile_scanner/src/enums/camera_facing.dart';
import 'package:mobile_scanner/src/enums/detection_speed.dart';
import 'package:mobile_scanner/src/mobile_scanner_exception.dart';
import 'package:mobile_scanner/src/mobile_scanner_platform_interface.dart';
import 'package:mobile_scanner/src/objects/barcode_capture.dart';
import 'package:mobile_scanner/src/objects/mobile_scanner_state.dart';

/// The controller for a [MobileScanner] widget.
class MobileScannerController extends ValueNotifier<MobileScannerState> {
  MobileScannerController({
    CameraFacing facing = CameraFacing.back,
    this.detectionSpeed = DetectionSpeed.normal,
    int detectionTimeoutMs = 250,
    this.torchEnabled = false,
    this.formats = const <BarcodeFormat>[],
    this.returnImage = false,
  })  : detectionTimeoutMs = detectionSpeed == DetectionSpeed.normal ? detectionTimeoutMs : 0,
        assert(detectionTimeoutMs >= 0, 'The detection timeout must be greater than or equal to 0.'),
        super(MobileScannerState.uninitialized(facing));

  /// The internal controller that keeps track of the scanned barcodes.
  final StreamController<BarcodeCapture> _barcodesController = StreamController.broadcast();

  bool _isDisposed = false;

  /// Get the stream of scanned barcodes.
  Stream<BarcodeCapture> get barcodes => _barcodesController.stream;

  /// The detection speed to use.
  ///
  /// Use caution when setting this to [DetectionSpeed.unrestricted]
  /// as it can cause memory issues on some devices.
  ///
  /// Defaults to [DetectionSpeed.normal].
  final DetectionSpeed detectionSpeed;

  /// The detection timeout of the scanner, in milliseconds.
  ///
  /// The detection timeout is ignored
  /// if the [detectionSpeed] is not [DetectionSpeed.normal].
  ///
  /// Defaults to 250 milliseconds.
  final int detectionTimeoutMs;

  /// The formats to scan for.
  final List<BarcodeFormat> formats;

  /// Whether to include the image in the barcode result.
  ///
  /// If this is true, the [BarcodeCapture.image] property can contain an image.
  ///
  /// This is only supported on iOS and Android, and defaults to false.
  final bool returnImage;

  /// Whether the flashlight on the device is enabled when starting the scanner.
  ///
  /// Defaults to false.
  final bool torchEnabled;

  void _checkNotDisposed() {
    if (_isDisposed) {
      throw const MobileScannerException(
        errorCode: MobileScannerErrorCode.controllerDisposed,
        errorDetails: MobileScannerErrorDetails(
          message: 'A MobileScannerController was used after being disposed.',
        ),
      );
    }
  }

  void _checkInitializedAndNotDisposed() {
    if (!value.isInitialized) {
      throw const MobileScannerException(
        errorCode: MobileScannerErrorCode.controllerUninitialized,
        errorDetails: MobileScannerErrorDetails(
          message: 'A MobileScannerController was used before being initialized.',
        ),
      );
    }

    _checkNotDisposed();
  }

  /// Initialize the mobile scanner.
  ///
  /// If [cameraDirection] is null,
  /// then the current camera direction of the controller is used.
  Future<void> initialize({
    CameraFacing? cameraDirection,
  }) async {
    _checkNotDisposed();

    final bool hasPermission = await MobileScannerPlatform.instance.requestCameraPermission();

    if (!hasPermission) {
      throw const MobileScannerException(
        errorCode: MobileScannerErrorCode.permissionDenied,
      );
    }

    final Map<String, Object?> scannerConfiguration = await MobileScannerPlatform.instance.initialize(
        // TODO: create a params object
        // TODO: pass the configuration options
        );

    // TODO: set camera facing state & other properties using copywith
  }

  /// Set the zoom scale of the camera.
  ///
  /// The zoom scale is clamped between `0.0` and `1.0`.
  Future<void> setZoomScale(double zoomScale) async {
    _checkInitializedAndNotDisposed();

    final double newZoomScale = clampDouble(zoomScale, 0.0, 1.0);

    await MobileScannerPlatform.instance.setZoomScale(newZoomScale);

    value = value.copyWith(zoomScale: newZoomScale);
  }

  /// Switch between the front and back camera on the device.
  ///
  /// Does nothing if the device has no camera to switch to.
  Future<void> switchCamera() async {
    _checkInitializedAndNotDisposed();

    // Dispose of the old camera.
    await MobileScannerPlatform.instance.dispose();

    final CameraFacing newDirection;

    switch (value.cameraDirection) {
      case CameraFacing.back:
        newDirection = CameraFacing.front;
        break;
      case CameraFacing.front:
        newDirection = CameraFacing.back;
        break;
    }

    await initialize(cameraDirection: newDirection);
  }

  /// Switches the flashlight on or off.
  ///
  /// Does nothing if the device has no flashlight.
  Future<void> toggleTorch() async {
    _checkInitializedAndNotDisposed();

    final TorchState currentState = value.torchState;

    switch (currentState) {
      case TorchState.off:
        const TorchState newState = TorchState.on;
        await MobileScannerPlatform.instance.setTorchState(newState);
        value = value.copyWith(torchState: newState);
        break;
      case TorchState.on:
        const TorchState newState = TorchState.off;
        await MobileScannerPlatform.instance.setTorchState(newState);
        value = value.copyWith(torchState: newState);
        break;
      case TorchState.unavailable:
        break;
    }
  }

  /// Dispose of this controller.
  ///
  /// Once the controller has been disposed, it cannot be used anymore.
  @override
  Future<void> dispose() async {
    if (_isDisposed) {
      return;
    }

    unawaited(_barcodesController.close());
    _isDisposed = true;
    super.dispose();

    // Disposing the controller also stops the camera.
    await MobileScannerPlatform.instance.dispose();
  }
}
