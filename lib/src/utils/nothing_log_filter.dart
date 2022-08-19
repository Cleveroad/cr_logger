import 'package:logger/logger.dart';

class NothingLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return false;
  }
}
