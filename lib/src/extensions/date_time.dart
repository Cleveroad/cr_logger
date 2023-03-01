import 'package:cr_logger/src/extensions/int_ext.dart';

extension DateTimeFormatter on DateTime {
  /// The same as [DateFormat('hh:mm:ss.SSS').format(this)]
  String formatTime() =>
      '${hour.leading}:${minute.leading}:${second.leading}.${millisecond.leading3}';

  /// The same as [DateFormat('yyyy MM dd hh:mm:ss.SSS').format(this)]
  String formatTimeWithYear() =>
      '$year-${month.leading}-${day.leading} ${formatTime()}';
}
