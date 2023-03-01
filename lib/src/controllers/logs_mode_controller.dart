import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/managers/log_manager.dart';
import 'package:flutter/cupertino.dart';

class LogsModeController extends ChangeNotifier {
  LogsModeController._();

  static LogsModeController instance = LogsModeController._();

  final ValueNotifier<LogsMode> logMode =
      ValueNotifier(LogsMode.fromCurrentSession);
  final ValueNotifier<bool> progressNotifier = ValueNotifier(false);

  bool get isFromCurrentSession => logMode.value == LogsMode.fromCurrentSession;

  bool _logsAreLoaded = false;

  Future<void> changeMode() async {
    progressNotifier.value = false;

    if (logMode.value == LogsMode.fromCurrentSession) {
      logMode.value = LogsMode.fromDB;
      if (!_logsAreLoaded) {
        progressNotifier.value = true;

        await _loadLogsFromDB();
        progressNotifier.value = false;
      }
      _logsAreLoaded = true;
    } else {
      logMode.value = LogsMode.fromCurrentSession;
    }
    notifyListeners();
  }

  Future<void> _loadLogsFromDB() => Future.wait([
        HttpLogManager.instance.loadLogsFromDB(),
        LogManager.instance.loadLogsFromDB(),
      ]);
}

enum LogsMode {
  fromCurrentSession('Current logs'),
  fromDB('DB logs');

  const LogsMode(this.appBarTitle);

  final String appBarTitle;
}
