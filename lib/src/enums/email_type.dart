/// Email format type constants.
enum EmailType {
  /// Unknown email type.
  unknown(0),

  /// Work email.
  work(1),

  /// Home email.
  home(2);

  const EmailType(this.rawValue);

  /// The raw email type value.
  final int rawValue;
}
