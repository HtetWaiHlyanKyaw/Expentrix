import 'package:flutter/material.dart';

Future<DateTime?> chooseDate(BuildContext context) async {
  return await showDatePicker(
    context: context,
    firstDate: DateTime(2000),
    lastDate: DateTime.now(),
  );
}

Future<DateTimeRange?> chooseDateRange(
  BuildContext context,
  DateTimeRange initialDateRange,
) async {
  return await showDateRangePicker(
    context: context,
    firstDate: DateTime(2000),
    lastDate: DateTime.now(),
    initialDateRange: initialDateRange,
  );
}

extension ThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
}

String formatAmount(double amount) {
  if (amount >= 1000000) {
    return '${(amount / 1000000).toStringAsFixed(1)} m';
  } else if (amount >= 1000) {
    return '${amount ~/ 1000} k';
  }
  return amount.toStringAsFixed(0);
}

int daysInMonth(int year, int month) {
  var beginningNextMonth = (month < 12)
      ? DateTime(year, month + 1, 1)
      : DateTime(year + 1, 1, 1);
  var lastDayOfMonth = beginningNextMonth.subtract(Duration(days: 1));
  return lastDayOfMonth.day;
}
