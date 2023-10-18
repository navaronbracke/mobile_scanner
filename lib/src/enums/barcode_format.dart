/// This enum defines the different barcode formats.
enum BarcodeFormat {
  /// A barcode format that represents all unknown formats.
  unknown(-1),

  /// A barcode format that represents all known formats.
  all(0),

  /// Barcode format constant for Code 128.
  code128(1),

  /// Barcode format constant for Code 39.
  code39(2),

  /// Barcode format constant for Code 93.
  code93(4),

  /// Barcode format constant for Codabar.
  codabar(8),

  /// Barcode format constant for Data Matrix.
  dataMatrix(16),

  /// Barcode format constant for EAN-13.
  ean13(32),

  /// Barcode format constant for EAN-8.
  ean8(64),

  /// Barcode format constant for ITF (Interleaved Two-of-Five).
  itf(128),

  /// Barcode format constant for QR Codes.
  qrCode(256),

  /// Barcode format constant for UPC-A.
  upcA(512),

  /// Barcode format constant for UPC-E.
  upcE(1024),

  /// Barcode format constant for PDF-417.
  pdf417(2048),

  /// Barcode format constant for AZTEC.
  aztec(4096);

  const BarcodeFormat(this.rawValue);

  /// The raw value of the barcode format.
  final int rawValue;
}
