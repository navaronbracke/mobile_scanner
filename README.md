# mobile_scanner

[![pub package](https://img.shields.io/pub/v/mobile_scanner.svg)](https://pub.dev/packages/mobile_scanner)
[![mobile_scanner](https://github.com/juliansteenbakker/mobile_scanner/actions/workflows/flutter.yml/badge.svg)](https://github.com/juliansteenbakker/mobile_scanner/actions/workflows/flutter.yml)
[![GitHub Sponsors](https://img.shields.io/github/sponsors/juliansteenbakker?label=like%20my%20work?%20sponsor%20me!)](https://github.com/sponsors/juliansteenbakker)

A universal scanner for Flutter based on MLKit. Uses CameraX on Android and AVFoundation on iOS.


## Features Supported

See the example app for detailed implementation information.

| Features               | Android            | iOS                | macOS | Web |
|------------------------|--------------------|--------------------|-------|-----|
| analyzeImage (Gallery) | :heavy_check_mark: | :heavy_check_mark: | :x:   | :x: |
| returnImage            | :heavy_check_mark: | :heavy_check_mark: | :x:   | :x: |
| scanWindow             | :heavy_check_mark: | :heavy_check_mark: | :x:   | :x: |
| barcodeOverlay         | :heavy_check_mark: | :heavy_check_mark: | :x:   | :x: |

## Platform Support

| Android | iOS | macOS | Web | Linux | Windows |
|---------|-----|-------|-----|-------|---------|
| ✔       | ✔   | ✔     | ✔   | :x:   | :x:     |

## Platform specific setup
### Android
This package uses by default the **bundled version** of MLKit Barcode-scanning for Android. This version is immediately available to the device. But it will increase the size of the app by approximately 3 to 10 MB.

The alternative is to use the **unbundled version** of MLKit Barcode-scanning for Android. This version is downloaded on first use via Google Play Services. It increases the app size by around 600KB.

[You can read more about the difference between the two versions here.](https://developers.google.com/ml-kit/vision/barcode-scanning/android)

To use the **unbundled version** of the MLKit Barcode-scanning, add the following line to your `/android/gradle.properties` file:
```
dev.steenbakker.mobile_scanner.useUnbundled=true
```

### iOS
**Add the following keys to your Info.plist file, located in <project root>/ios/Runner/Info.plist:**
NSCameraUsageDescription - describe why your app needs access to the camera. This is called Privacy - Camera Usage Description in the visual editor.

**If you want to use the local gallery feature from [image_picker](https://pub.dev/packages/image_picker)**
NSPhotoLibraryUsageDescription - describe why your app needs permission for the photo library. This is called Privacy - Photo Library Usage Description in the visual editor.

  Example,
  ```
  <key>NSCameraUsageDescription</key>
  <string>This app needs camera access to scan QR codes</string>

  <key>NSPhotoLibraryUsageDescription</key>
  <string>This app needs photos access to get QR code from photo library</string>
  ```


### macOS
Ensure that you granted camera permission in XCode -> Signing & Capabilities:

<img width="696" alt="Screenshot of XCode where Camera is checked" src="https://user-images.githubusercontent.com/24459435/193464115-d76f81d0-6355-4cb2-8bee-538e413a3ad0.png">

## Web
This package uses ZXing on web to read barcodes so it needs to be included in `index.html` as script.
```html
<script src="https://unpkg.com/@zxing/library@0.19.1" type="application/javascript"></script>
```

## Usage

_See the example app for a detailed example._

Import `package:mobile_scanner/mobile_scanner.dart`, and use the widget with or without the controller.

If you don't provide a controller, you can't control functions like the torch(flash) or switching camera.

If you don't set `detectionSpeed` to `DetectionSpeed.noDuplicates`, you can get multiple scans in a very short time, causing things like pop() to fire lots of times.

### BarcodeCapture

The onDetect function returns a BarcodeCapture objects which contains the following items.

| Property name | Type          | Description                       |
|---------------|---------------|-----------------------------------|
| barcodes      | List<Barcode> | A list with scanned barcodes.     |
| image         | Uint8List?    | If enabled, an image of the scan. |

You can use the following properties of the Barcode object.

| Property name | Type           | Description                         |
|---------------|----------------|-------------------------------------|
| format        | BarcodeFormat  |                                     |
| rawBytes      | Uint8List?     | binary scan result                  |
| rawValue      | String?        | Value if barcode is in UTF-8 format |
| displayValue  | String?        |                                     |
| type          | BarcodeType    |                                     |
| calendarEvent | CalendarEvent? |                                     |
| contactInfo   | ContactInfo?   |                                     |
| driverLicense | DriverLicense? |                                     |
| email         | Email?         |                                     |
| geoPoint      | GeoPoint?      |                                     |
| phone         | Phone?         |                                     |
| sms           | SMS?           |                                     |
| url           | UrlBookmark?   |                                     |
| wifi          | WiFi?          | WiFi Access-Point details           |
