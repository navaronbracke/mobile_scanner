import 'package:mobile_scanner/src/enums/address_type.dart';

/// An address.
class Address {
  /// Creates a new [Address] instance.
  const Address({
    this.addressLines = const <String>[],
    this.type = AddressType.unknown,
  });

  /// Creates a new [Address] instance from a map.
  factory Address.fromMap(Map<Object?, Object?>? data) {
    if (data == null) {
      return const Address();
    }

    final List<Object?>? addressLines = data['addressLines'] as List<Object?>?;
    final AddressType type = AddressType.fromRawValue(
      data['type'] as int? ?? 0,
    );

    if (addressLines == null) {
      return Address(type: type);
    }

    return Address(addressLines: List.unmodifiable(addressLines), type: type);
  }

  /// The address lines that represent this address.
  final List<String> addressLines;

  /// Gets type of the address.
  final AddressType type;
}
