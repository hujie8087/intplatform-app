import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  static final _formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

  String get startOfDay => _formatter.format(DateTime(year, month, day));

  String get endOfDay =>
      _formatter.format(DateTime(year, month, day, 23, 59, 59, 999));

  String get startOfWeek {
    final dayOfWeek = weekday;
    final start = subtract(Duration(days: dayOfWeek - 1));
    return _formatter.format(DateTime(start.year, start.month, start.day));
  }

  String get endOfWeek {
    final dayOfWeek = weekday;
    final end = add(Duration(days: 7 - dayOfWeek));
    return _formatter.format(
      DateTime(end.year, end.month, end.day, 23, 59, 59, 999),
    );
  }

  String get startOfMonth => _formatter.format(DateTime(year, month, 1));

  String get endOfMonth =>
      _formatter.format(DateTime(year, month + 1, 0, 23, 59, 59, 999));

  String get startOfQuarter {
    final quarterStartMonth = ((month - 1) ~/ 3) * 3 + 1;
    return _formatter.format(DateTime(year, quarterStartMonth, 1));
  }

  String get endOfQuarter {
    final quarterStartMonth = ((month - 1) ~/ 3) * 3 + 1;
    final lastMonth = quarterStartMonth + 2;
    return _formatter.format(DateTime(year, lastMonth + 1, 0, 23, 59, 59, 999));
  }

  String get startOfYear => _formatter.format(DateTime(year, 1, 1));

  String get endOfYear =>
      _formatter.format(DateTime(year, 12, 31, 23, 59, 59, 999));
}

String formatDateTime(String? date) {
  if (date == null) return '';
  try {
    final dateTime = DateTime.parse(date);
    final formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    return formattedDate;
  } catch (e) {
    return '';
  }
}
