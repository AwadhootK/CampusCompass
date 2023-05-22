import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static Future<void> saveCount(String subject, DateTime startDate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(subject, startDate.toIso8601String());
  }

  static Future<Duration> getCount(String subject) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(subject);
    if (value != null) {
      return DateFormat('yyyy-MM-ddTHH:mm:ss')
          .parse(value)
          .difference(DateTime.now());
    } else {
      return Duration.zero;
    }
  }

  static Future<void> deleteSP(String subject) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(subject);
  }
}
