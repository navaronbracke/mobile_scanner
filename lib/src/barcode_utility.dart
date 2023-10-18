import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

Size toSize(Map data) {
  final width = data['width'] as double;
  final height = data['height'] as double;
  return Size(width, height);
}

List<Offset>? toCorners(List<Map<Object?, Object?>>? data) {
  if (data == null) {
    return null;
  }

  return List.unmodifiable(
    data.map((Map<Object?, Object?> e) {
      return Offset(e['x']! as double, e['y']! as double);
    }),
  );
}

CalendarEvent? toCalendarEvent(Map? data) {
  if (data != null) {
    return CalendarEvent.fromNative(data);
  } else {
    return null;
  }
}

DateTime? toDateTime(Map<String, dynamic>? data) {
  if (data != null) {
    final year = data['year'] as int;
    final month = data['month'] as int;
    final day = data['day'] as int;
    final hour = data['hours'] as int;
    final minute = data['minutes'] as int;
    final second = data['seconds'] as int;
    return data['isUtc'] as bool
        ? DateTime.utc(year, month, day, hour, minute, second)
        : DateTime(year, month, day, hour, minute, second);
  } else {
    return null;
  }
}

ContactInfo? toContactInfo(Map? data) {
  if (data != null) {
    return ContactInfo.fromNative(data);
  } else {
    return null;
  }
}

PersonName? toName(Map? data) {
  if (data != null) {
    return PersonName.fromNative(data);
  } else {
    return null;
  }
}

DriverLicense? toDriverLicense(Map? data) {
  if (data != null) {
    return DriverLicense.fromNative(data);
  } else {
    return null;
  }
}

Email? toEmail(Map? data) {
  if (data != null) {
    return Email.fromNative(data);
  } else {
    return null;
  }
}

GeoPoint? toGeoPoint(Map? data) {
  if (data != null) {
    return GeoPoint.fromNative(data);
  } else {
    return null;
  }
}

Phone? toPhone(Map? data) {
  if (data != null) {
    return Phone.fromNative(data);
  } else {
    return null;
  }
}

SMS? toSMS(Map? data) {
  if (data != null) {
    return SMS.fromNative(data);
  } else {
    return null;
  }
}

UrlBookmark? toUrl(Map? data) {
  if (data != null) {
    return UrlBookmark.fromNative(data);
  } else {
    return null;
  }
}

WiFi? toWiFi(Map? data) {
  if (data != null) {
    return WiFi.fromNative(data);
  } else {
    return null;
  }
}
