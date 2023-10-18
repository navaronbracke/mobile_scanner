/// Phone number format type constants.
enum PhoneType {
  /// Unknown phone type.
  unknown(0),

  /// Work phone.
  work(1),

  /// Home phone.
  home(2),

  /// Fax machine.
  fax(3),

  /// Mobile phone.
  mobile(4);

  const PhoneType(this.rawValue);

  /// The raw phone type value.
  final int rawValue;
}
