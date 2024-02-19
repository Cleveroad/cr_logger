import 'package:logger/logger.dart';

final class NothingLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return false;
  }
}
