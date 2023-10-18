/// GPS coordinates from a `GEO:` or similar QRCode type.
class GeoPoint {
  /// Construct a new [GeoPoint] instance.
  const GeoPoint({
    this.latitude = 0.0,
    this.longitude = 0.0,
  });

  /// Construct a [GeoPoint] from the given [data].
  factory GeoPoint.fromMap(Map<Object?, Object?> data) {
    return GeoPoint(
      latitude: data['latitude'] as double? ?? 0.0,
      longitude: data['longitude'] as double? ?? 0.0,
    );
  }

  /// The latitude of the coordinate.
  final double latitude;

  /// The longitude of the coordinate.
  final double longitude;
}
