/// GPS coordinates from a `GEO:` or similar QRCode type.
class GeoPoint {
  /// Construct a new [GeoPoint] instance.
  const GeoPoint({
    this.latitude,
    this.longitude,
  });

  /// Construct a [GeoPoint] from the given [data].
  factory GeoPoint.fromMap(Map<Object?, Object?>? data) {
    if (data == null) {
      return const GeoPoint();
    }

    return GeoPoint(
      latitude: data['latitude'] as double?,
      longitude: data['longitude'] as double?,
    );
  }

  /// The latitude of the coordinate.
  final double? latitude;

  /// The longitude of the coordinate.
  final double? longitude;
}
