import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/src/enums/mobile_scanner_authorization_state.dart';
import 'package:mobile_scanner/src/enums/mobile_scanner_error_code.dart';
import 'package:mobile_scanner/src/enums/torch_state.dart';
import 'package:mobile_scanner/src/mobile_scanner_exception.dart';
import 'package:mobile_scanner/src/mobile_scanner_platform_interface.dart';
import 'package:mobile_scanner/src/objects/mobile_scanner_options.dart';

/// An implementation of [MobileScannerPlatform] that uses method channels.
class MethodChannelMobileScanner extends MobileScannerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('dev.steenbakker.mobile_scanner/scanner/method');

  /// The event channel that sends back scanned barcode events.
  @visibleForTesting
  final eventChannel = const EventChannel('dev.steenbakker.mobile_scanner/scanner/event');

  StreamSubscription<Object?>? _eventsSubscription;

  @override
  Future<bool> analyzeImage(String path) {
    /*
        events ??= _eventChannel
        .receiveBroadcastStream()
        .listen((data) => _handleEvent(data as Map));

    return _methodChannel
        .invokeMethod<bool>('analyzeImage', path)
        .then<bool>((bool? value) => value ?? false);
    */
  }

  @override
  Future<Map<String, Object?>> initialize(MobileScannerOptions options) async {
    _eventsSubscription ??= eventChannel.receiveBroadcastStream().cast<Map<String, Object?>>().listen(_handleEvent);

    Map<String, Object?>? configuration;

    final Map<String, Object?> arguments = {
      'facing': cameraDirection.index,
      'returnImage': returnImage,
      'speed': detectionSpeed.index,
      'timeout': detectionTimeoutMs,
      'torch': torchEnabled,
    };

    // TODO: refactor Android to use the raw value as well
    if (formats != null) {
      if (Platform.isIOS || Platform.isMacOS) {
        arguments['formats'] = formats.map((e) => e.rawValue).toList();
      } else if (Platform.isAndroid) {
        arguments['formats'] = formats.map((e) => e.index).toList();
      }
    }

    try {
      configuration = await methodChannel.invokeMapMethod<String, Object?>(
        'start',
        arguments,
      );
    } on PlatformException catch (error) {
      throw MobileScannerException(
        errorCode: MobileScannerErrorCode.genericError,
        errorDetails: MobileScannerErrorDetails(
          code: error.code,
          details: error.details as Object?,
          message: error.message,
        ),
      );
    }

    // TODO
  }

  @override
  Future<void> setTorchState(TorchState state) async {
    if (state != TorchState.unavailable) {
      await methodChannel.invokeMethod('torch', state.index);
    }
  }

  @override
  Future<void> setZoomScale(double zoomScale) async {
    await methodChannel.invokeMethod('setScale', zoomScale);
  }

  @override
  Future<bool> requestCameraPermission() async {
    final MobileScannerAuthorizationState state =
        MobileScannerAuthorizationState.fromRawValue(await methodChannel.invokeMethod<int>('state') ?? -1);

    switch (state) {
      case MobileScannerAuthorizationState.undetermined:
        try {
          final bool result = await methodChannel.invokeMethod<bool>('request') ?? false;

          return result;
        } on PlatformException catch (error) {
          throw MobileScannerException(
            errorCode: MobileScannerErrorCode.genericError,
            errorDetails: MobileScannerErrorDetails(
              code: error.code,
              details: error.details as Object?,
              message: error.message,
            ),
          );
        }
      case MobileScannerAuthorizationState.denied:
        return false;
      case MobileScannerAuthorizationState.authorized:
        return true;
    }
  }

  @override
  Future<void> resetZoomScale() {
    return methodChannel.invokeMethod<void>('resetScale');
  }

  @override
  Future<void> updateScanWindow(Rect? window) async {
    List<double>? points;

    if (window != null) {
      points = [window.left, window.top, window.right, window.bottom];
    }

    await methodChannel.invokeMethod('updateScanWindow', {'rect': points});
  }

  @override
  Future<void> dispose() async {
    _eventsSubscription?.cancel();
    _eventsSubscription = null;

    await methodChannel.invokeMethod('stop');
  }
}
