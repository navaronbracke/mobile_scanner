/// Address type constants.
enum AddressType {
  /// Unknown address type.
  unknown(0),

  /// Work address.
  work(1),

  /// Home address.
  home(2);

  const AddressType(this.rawValue);

  /// The raw address type value.
  final int rawValue;
}
