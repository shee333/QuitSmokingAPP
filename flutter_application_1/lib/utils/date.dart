import 'package:intl/intl.dart';

DateTime todayLocal() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

String dateKey(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

List<DateTime> recentDays({int days = 7}) {
  final List<DateTime> result = [];
  final base = todayLocal();
  for (int i = days - 1; i >= 0; i--) {
    result.add(base.subtract(Duration(days: i)));
  }
  return result;
}


