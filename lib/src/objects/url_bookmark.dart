/// A URL and title from a `MEBKM:` or similar QRCode type.
class UrlBookmark {
  /// Construct a new [UrlBookmark] instance.
  const UrlBookmark({
    this.title,
    this.url,
  });

  /// Construct a new [UrlBookmark] instance from the given [data].
  factory UrlBookmark.fromMap(Map<Object?, Object?>? data) {
    if (data == null) {
      return const UrlBookmark();
    }

    return UrlBookmark(
      title: data['title'] as String?,
      url: data['url'] as String?,
    );
  }

  /// The title of the bookmark.
  final String? title;

  /// The url of the bookmark.
  final String? url;
}
