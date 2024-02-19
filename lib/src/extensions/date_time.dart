import 'package:cr_logger/src/extensions/int_ext.dart';
import 'package:flutter/material.dart';

extension DateTimeFormatter on DateTime {
  /// The same as [DateFormat('yyyy MM dd hh:mm:ss.SSS').format(this)]
  String formatTimeWithYear(BuildContext context) =>
      '$year-${month.leading}-${day.leading} ${formatTime(context)}';

  /// The same as [DateFormat('hh:mm:ss.SSS').format(this)]
  String formatTime(BuildContext context) {
    final userUse24HourFormat = MediaQuery.of(context).alwaysUse24HourFormat;

    return userUse24HourFormat
        ? '${hour.leading}:${minute.leading}:${second.leading}.${millisecond.leading3}'
        : formatted12HourString;
  }

  // TODO: make this using intl package later, when all packages move to 0.18.0 version
  /// Returns time from DateTime in 12H format (19:35 => 07:35 PM)
  String get formatted12HourString {
    final time = TimeOfDay.fromDateTime(this);
    final buffer = StringBuffer();
    final hours12hFormat = time.hour - time.periodOffset;
    final hoursStr =
        hours12hFormat < 10 ? '0$hours12hFormat' : hours12hFormat.toString();
    final minutesStr =
        time.minute < 10 ? '0${time.minute}' : time.minute.toString();
    final periodStr = time.period.name;
    buffer.writeAll([
      hoursStr,
      ':',
      minutesStr,
      ' ',
      periodStr,
    ]);

    return buffer.toString().toUpperCase();
  }
}
