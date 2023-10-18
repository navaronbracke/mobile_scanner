import 'dart:typed_data';
import 'dart:ui';

import 'package:mobile_scanner/src/barcode_utility.dart';

/// Represents a single recognized barcode and its value.
class Barcode {
  /// Returns four corner points in clockwise direction starting with top-left.
  ///
  /// Due to the possible perspective distortions, this is not necessarily a rectangle.
  ///
  /// Returns null if the corner points can not be determined.
  final List<Offset>? corners;

  /// Returns barcode format
  final BarcodeFormat format;

  /// Returns raw bytes as it was encoded in the barcode.
  ///
  /// Returns null if the raw bytes can not be determined.
  final Uint8List? rawBytes;

  /// Returns barcode value as it was encoded in the barcode. Structured values are not parsed, for example: 'MEBKM:TITLE:Google;URL://www.google.com;;'.
  ///
  /// It's only available when the barcode is encoded in the UTF-8 format, and for non-UTF8 ones use [rawBytes] instead.
  ///
  /// Returns null if the raw value can not be determined.
  final String? rawValue;

  /// Returns barcode value in a user-friendly format.
  ///
  /// This method may omit some of the information encoded in the barcode. For example, if [rawValue] returns 'MEBKM:TITLE:Google;URL://www.google.com;;', the display value might be '//www.google.com'.
  ///
  /// This value may be multiline, for example, when line breaks are encoded into the original TEXT barcode value. May include the supplement value.
  ///
  /// Returns null if nothing found.
  final String? displayValue;

  /// Returns format type of the barcode value.
  ///
  /// For example, TYPE_TEXT, TYPE_PRODUCT, TYPE_URL, etc.
  ///
  /// If the value structure cannot be parsed, TYPE_TEXT will be returned. If the recognized structure type is not defined in your current version of SDK, TYPE_UNKNOWN will be returned.
  ///
  /// Note that the built-in parsers only recognize a few popular value structures. For your specific use case, you might want to directly consume rawValue and implement your own parsing logic.
  final BarcodeType type;

  /// Gets parsed calendar event details.
  final CalendarEvent? calendarEvent;

  /// Gets parsed contact details.
  final ContactInfo? contactInfo;

  /// Gets parsed driver license details.
  final DriverLicense? driverLicense;

  /// Gets parsed email details.
  final Email? email;

  /// Gets parsed geo coordinates.
  final GeoPoint? geoPoint;

  /// Gets parsed phone number details.
  final Phone? phone;

  /// Gets parsed SMS details.
  final SMS? sms;

  /// Gets parsed URL bookmark details.
  final UrlBookmark? url;

  /// Gets parsed WiFi AP details.
  final WiFi? wifi;

  Barcode({
    this.corners,
    this.format = BarcodeFormat.ean13,
    this.rawBytes,
    this.type = BarcodeType.text,
    this.calendarEvent,
    this.contactInfo,
    this.driverLicense,
    this.email,
    this.geoPoint,
    this.phone,
    this.sms,
    this.url,
    this.wifi,
    this.displayValue,
    required this.rawValue,
  });

  /// Create a [Barcode] from native data.
  Barcode.fromNative(Map data)
      : corners = toCorners(
          (data['corners'] as List?)?.cast<Map<Object?, Object?>>(),
        ),
        format = toFormat(data['format'] as int),
        rawBytes = data['rawBytes'] as Uint8List?,
        rawValue = data['rawValue'] as String?,
        displayValue = data['displayValue'] as String?,
        type = BarcodeType.values[data['type'] as int],
        calendarEvent = toCalendarEvent(data['calendarEvent'] as Map?),
        contactInfo = toContactInfo(data['contactInfo'] as Map?),
        driverLicense = toDriverLicense(data['driverLicense'] as Map?),
        email = toEmail(data['email'] as Map?),
        geoPoint = toGeoPoint(data['geoPoint'] as Map?),
        phone = toPhone(data['phone'] as Map?),
        sms = toSMS(data['sms'] as Map?),
        url = toUrl(data['url'] as Map?),
        wifi = toWiFi(data['wifi'] as Map?);
}

/// A calendar event extracted from QRCode.
class CalendarEvent {
  /// Gets the description of the calendar event.
  ///
  /// Returns null if not available.
  final String? description;

  /// Gets the start date time of the calendar event.
  ///
  /// Returns null if not available.
  final DateTime? start;

  /// Gets the end date time of the calendar event.
  ///
  /// Returns null if not available.
  final DateTime? end;

  /// Gets the location of the calendar event.
  ///
  /// Returns null if not available.
  final String? location;

  /// Gets the organizer of the calendar event.
  ///
  /// Returns null if not available.
  final String? organizer;

  /// Gets the status of the calendar event.
  ///
  /// Returns null if not available.
  final String? status;

  /// Gets the summary of the calendar event.
  ///
  /// Returns null if not available.
  final String? summary;

  /// Create a [CalendarEvent] from native data.
  CalendarEvent.fromNative(Map data)
      : description = data['description'] as String?,
        start = data['start'] != null
            ? DateTime.tryParse(data['start'] as String)
            : null,
        end = data['end'] != null
            ? DateTime.tryParse(data['end'] as String)
            : null,
        location = data['location'] as String?,
        organizer = data['organizer'] as String?,
        status = data['status'] as String?,
        summary = data['summary'] as String?;
}

/// A person's or organization's business card. For example a VCARD.
class ContactInfo {
  /// Gets contact person's addresses.
  ///
  /// Returns an empty list if nothing found.
  final List<Address> addresses;

  /// Gets contact person's emails.
  ///
  /// Returns an empty list if nothing found.
  final List<Email> emails;

  /// Gets contact person's name.
  ///
  /// Returns null if not available.
  final PersonName? name;

  /// Gets contact person's organization.
  ///
  /// Returns null if not available.
  final String? organization;

  /// Gets contact person's phones.
  ///
  /// Returns an empty list if nothing found.
  final List<Phone>? phones;

  /// Gets contact person's title.
  ///
  /// Returns null if not available.
  final String? title;

  /// Gets contact person's urls.
  ///
  /// Returns an empty list if nothing found.
  final List<String>? urls;

  /// Create a [ContactInfo] from native data.
  ContactInfo.fromNative(Map data)
      : addresses = List.unmodifiable(
          (data['addresses'] as List? ?? [])
              .cast<Map>()
              .map(Address.fromNative),
        ),
        emails = List.unmodifiable(
          (data['emails'] as List? ?? []).cast<Map>().map(Email.fromNative),
        ),
        name = toName(data['name'] as Map?),
        organization = data['organization'] as String?,
        phones = List.unmodifiable(
          (data['phones'] as List? ?? []).cast<Map>().map(Phone.fromNative),
        ),
        title = data['title'] as String?,
        urls = List.unmodifiable((data['urls'] as List? ?? []).cast<String>());
}
