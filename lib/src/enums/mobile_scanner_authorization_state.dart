/// The authorization state of the scanner.
enum MobileScannerAuthorizationState {
  /// The scanner has not yet requested the required permissions.
  undetermined,

  /// The scanner has the required permissions.
  authorized,

  /// The user denied the required permissions.
  denied;

  factory MobileScannerAuthorizationState.fromRawValue(int value) {
    switch (value) {
      case 0:
        return MobileScannerAuthorizationState.undetermined;
      case 1:
        return MobileScannerAuthorizationState.authorized;
      case 2:
        return MobileScannerAuthorizationState.denied;
      default:
        throw ArgumentError.value(value, 'value', 'Invalid raw value.');
    }
  }
}
