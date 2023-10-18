import 'package:mobile_scanner/src/enums/phone_type.dart';

/// Phone number information from a barcode.
class PhoneNumber {
  /// Construct a new [PhoneNumber] instance.
  const PhoneNumber({
    this.number,
    this.type = PhoneType.unknown,
  });

  /// Create a [PhoneNumber] from the given [data].
  factory PhoneNumber.fromMap(Map<Object?, Object?> data) {
    return PhoneNumber(
      number: data['number'] as String?,
      type: PhoneType.fromRawValue(data['type'] as int? ?? 0),
    );
  }

  /// The phone number value.
  final String? number;

  /// The type of phone number.
  final PhoneType type;
}
