/// Barcode value type constants.
enum BarcodeType {
  /// An unknown barcode type.
  unknown(0),

  /// Barcode value type constant for contact information.
  contactInfo(1),

  /// Barcode value type constant for email message details.
  email(2),

  /// Barcode value type constant for ISBNs.
  isbn(3),

  /// Barcode value type constant for phone numbers.
  phone(4),

  /// Barcode value type constant for product codes.
  product(5),

  /// Barcode value type constant for SMS details.
  sms(6),

  /// Barcode value type constant for plain text.
  text(7),

  /// Barcode value type constant for URLs or bookmarks.
  url(8),

  /// Barcode value type constant for WiFi access point details.
  wifi(9),

  /// Barcode value type constant for geographic coordinates.
  geo(10),

  /// Barcode value type constant for calendar events.
  calendarEvent(11),

  /// Barcode value type constant for driver license data.
  driverLicense(12);

  const BarcodeType(this.rawValue);

  /// The raw barcode type value.
  final int rawValue;
}
