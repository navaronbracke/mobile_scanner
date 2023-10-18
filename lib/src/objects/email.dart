import 'package:mobile_scanner/src/enums/email_type.dart';

/// An email message from a 'MAILTO:' or similar QRCode type.
class Email {
  /// Construct a new [Email] instance.
  const Email({
    this.address,
    this.body,
    this.subject,
    this.type = EmailType.unknown,
  });

  /// Construct an [Email] from the given [data].
  factory Email.fromMap(Map<Object?, Object?>? data) {
    if (data == null) {
      return const Email();
    }

    return Email(
      address: data['address'] as String?,
      body: data['body'] as String?,
      subject: data['subject'] as String?,
      type: EmailType.fromRawValue(data['type'] as int? ?? 0),
    );
  }

  /// The email address.
  final String? address;

  /// The body of the email.
  final String? body;

  /// The subject of the email.
  final String? subject;

  /// The type of email.
  final EmailType type;
}
