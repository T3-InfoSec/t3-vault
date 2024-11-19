import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';

class TimeZoneHelper {

  static const String defaultTimeZoneName = 'UTC';

  static Future<void> initialize() async {
    tz.initializeTimeZones();
    String timeZoneName = kIsWeb ? DateTime.now().timeZoneName : defaultTimeZoneName;
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  static tz.TZDateTime toLocalTime(DateTime dateTime) {
    return tz.TZDateTime.from(dateTime, tz.local);
  }
}
