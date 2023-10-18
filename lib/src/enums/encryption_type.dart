/// Wifi encryption type constants.
enum EncryptionType {
  /// Unknown encryption type.
  none(0),

  /// Not encrypted.
  open(1),

  /// WPA level encryption.
  wpa(2),

  /// WEP level encryption.
  wep(3);

  const EncryptionType(this.rawValue);

  /// The raw value for the encryption type.
  final int rawValue;
}
