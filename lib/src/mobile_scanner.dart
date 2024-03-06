import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/src/enums/mobile_scanner_error_code.dart';
import 'package:mobile_scanner/src/mobile_scanner_controller.dart';
import 'package:mobile_scanner/src/mobile_scanner_exception.dart';
import 'package:mobile_scanner/src/objects/barcode_capture.dart';
import 'package:mobile_scanner/src/objects/mobile_scanner_arguments.dart';
import 'package:mobile_scanner/src/scan_window_calculation.dart';

/// The function signature for the error builder.
typedef MobileScannerErrorBuilder = Widget Function(
  BuildContext,
  MobileScannerException,
  Widget?,
);

/// The [MobileScanner] widget displays a live camera preview.
class MobileScanner extends StatefulWidget {
  /// The controller that manages the barcode scanner.
  ///
  /// If this is null, the scanner will manage its own controller.
  final MobileScannerController? controller;

  /// The function that builds an error widget when the scanner
  /// could not be started.
  ///
  /// If this is null, defaults to a black [ColoredBox]
  /// with a centered white [Icons.error] icon.
  final MobileScannerErrorBuilder? errorBuilder;

  /// The [BoxFit] for the camera preview.
  ///
  /// Defaults to [BoxFit.cover].
  final BoxFit fit;

  /// The function that signals when new codes were detected by the [controller].
  final void Function(BarcodeCapture barcodes) onDetect;

  /// The function that signals when the barcode scanner is started.
  @Deprecated('Use onScannerStarted() instead.')
  final void Function(MobileScannerArguments? arguments)? onStart;

  /// The function that signals when the barcode scanner is started.
  final void Function(MobileScannerArguments? arguments)? onScannerStarted;

  /// The function that builds a placeholder widget when the scanner
  /// is not yet displaying its camera preview.
  ///
  /// If this is null, a black [ColoredBox] is used as placeholder.
  final Widget Function(BuildContext, Widget?)? placeholderBuilder;

  /// if set barcodes will only be scanned if they fall within this [Rect]
  /// useful for having a cut-out overlay for example. these [Rect]
  /// coordinates are relative to the widget size, so by how much your
  /// rectangle overlays the actual image can depend on things like the
  /// [BoxFit]
  final Rect? scanWindow;

  /// The threshold for updates to the [scanWindow].
  ///
  /// If the [scanWindow] would be updated,
  /// due to new layout constraints for the scanner,
  /// and the width or height of the new scan window have not changed by this threshold,
  /// then the scan window is not updated.
  ///
  /// It is recommended to set this threshold
  /// if scan window updates cause performance issues.
  ///
  /// Defaults to no threshold for scan window updates.
  final double scanWindowUpdateThreshold;

  /// Only set this to true if you are starting another instance of mobile_scanner
  /// right after disposing the first one, like in a PageView.
  ///
  /// Default: false
  final bool startDelay;

  /// The overlay which will be painted above the scanner when has started successful.
  /// Will no be pointed when an error occurs or the scanner hasn't been started yet.
  final Widget? overlay;

  /// Create a new [MobileScanner] using the provided [controller]
  /// and [onBarcodeDetected] callback.
  const MobileScanner({
    this.controller,
    this.errorBuilder,
    this.fit = BoxFit.cover,
    required this.onDetect,
    @Deprecated('Use onScannerStarted() instead.') this.onStart,
    this.onScannerStarted,
    this.placeholderBuilder,
    this.scanWindow,
    this.scanWindowUpdateThreshold = 0.0,
    this.startDelay = false,
    this.overlay,
    super.key,
  });

  @override
  State<MobileScanner> createState() => _MobileScannerState();
}

class _MobileScannerState extends State<MobileScanner>
    with WidgetsBindingObserver {
  /// The subscription that listens to barcode detection.
  StreamSubscription<BarcodeCapture>? _barcodesSubscription;

  /// The internally managed controller.
  late MobileScannerController _controller;

  /// Whether the controller should resume
  /// when the application comes back to the foreground.
  bool _resumeFromBackground = false;

  MobileScannerException? _startException;

  Widget _buildPlaceholderOrError(BuildContext context, Widget? child) {
    final error = _startException;

    if (error != null) {
      return widget.errorBuilder?.call(context, error, child) ??
          const ColoredBox(
            color: Colors.black,
            child: Center(child: Icon(Icons.error, color: Colors.white)),
          );
    }

    return widget.placeholderBuilder?.call(context, child) ??
        const ColoredBox(color: Colors.black);
  }

  /// Start the given [scanner].
  Future<void> _startScanner() async {
    if (widget.startDelay) {
      await Future.delayed(const Duration(seconds: 1, milliseconds: 500));
    }

    _barcodesSubscription ??= _controller.barcodes.listen(
      widget.onDetect,
    );

    if (!_controller.autoStart) {
      debugPrint(
        'mobile_scanner: not starting automatically because autoStart is set to false in the controller.',
      );
      return;
    }

    _controller.start().then((arguments) {
      // ignore: deprecated_member_use_from_same_package
      widget.onStart?.call(arguments);
      widget.onScannerStarted?.call(arguments);
    }).catchError((error) {
      if (!mounted) {
        return;
      }

      if (error is MobileScannerException) {
        _startException = error;
      } else if (error is PlatformException) {
        _startException = MobileScannerException(
          errorCode: MobileScannerErrorCode.genericError,
          errorDetails: MobileScannerErrorDetails(
            code: error.code,
            message: error.message,
            details: error.details,
          ),
        );
      } else {
        _startException = MobileScannerException(
          errorCode: MobileScannerErrorCode.genericError,
          errorDetails: MobileScannerErrorDetails(
            details: error,
          ),
        );
      }

      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = widget.controller ?? MobileScannerController();
    _startScanner();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before the controller was initialized.
    if (_controller.isStarting) {
      return;
    }

    switch (state) {
      case AppLifecycleState.resumed:
        if (_resumeFromBackground) {
          _startScanner();
        }
      case AppLifecycleState.inactive:
        _resumeFromBackground = true;
        _controller.stop();
      default:
        break;
    }
  }

  Rect? scanWindow;

  /// Calculate the scan window based on the given [constraints].
  ///
  /// If the [scanWindow] is already set, this method does nothing.
  void _maybeUpdateScanWindow(
    Size textureSize,
    BoxConstraints constraints,
  ) {
    if (widget.scanWindow == null) {
      return;
    }

    final Rect newScanWindow = calculateScanWindowRelativeToTextureInPercentage(
      widget.fit,
      widget.scanWindow!,
      textureSize: textureSize,
      widgetSize: constraints.biggest,
    );

    // The scan window was never set before.
    // Set the initial scan window.
    if (scanWindow == null) {
      scanWindow = newScanWindow;

      unawaited(_controller.updateScanWindow(scanWindow));

      return;
    }

    // The scan window did not not change.
    // The left, right, top and bottom are the same.
    if (scanWindow == newScanWindow) {
      return;
    }

    // The update threshold is not set, allow updating the scan window.
    if (widget.scanWindowUpdateThreshold == 0.0) {
      scanWindow = newScanWindow;

      unawaited(_controller.updateScanWindow(scanWindow));

      return;
    }

    final double dx = (newScanWindow.width - scanWindow!.width).abs();
    final double dy = (newScanWindow.height - scanWindow!.height).abs();

    // The new scan window has changed enough, allow updating the scan window.
    if (dx >= widget.scanWindowUpdateThreshold ||
        dy >= widget.scanWindowUpdateThreshold) {
      scanWindow = newScanWindow;

      unawaited(_controller.updateScanWindow(scanWindow));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ValueListenableBuilder<MobileScannerArguments?>(
          valueListenable: _controller.startArguments,
          builder: (context, value, child) {
            if (value == null) {
              return _buildPlaceholderOrError(context, child);
            }

            _maybeUpdateScanWindow(value.size, constraints);

            if (widget.overlay != null) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  _scanner(
                    value.size,
                    value.webId,
                    value.textureId,
                    value.numberOfCameras,
                  ),
                  widget.overlay!,
                ],
              );
            } else {
              return _scanner(
                value.size,
                value.webId,
                value.textureId,
                value.numberOfCameras,
              );
            }
          },
        );
      },
    );
  }

  Widget _scanner(
    Size size,
    String? webId,
    int? textureId,
    int? numberOfCameras,
  ) {
    return ClipRect(
      child: LayoutBuilder(
        builder: (_, constraints) {
          return SizedBox.fromSize(
            size: constraints.biggest,
            child: FittedBox(
              fit: widget.fit,
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: kIsWeb
                    ? HtmlElementView(viewType: webId!)
                    : Texture(textureId: textureId!),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.updateScanWindow(null);
    WidgetsBinding.instance.removeObserver(this);
    _barcodesSubscription?.cancel();
    _barcodesSubscription = null;
    _controller.dispose();
    super.dispose();
  }
}
