import 'dart:async';

import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/controllers/logs_mode_controller.dart';
import 'package:cr_logger/src/cr_logger_helper.dart';
import 'package:cr_logger/src/providers/sqflite_provider.dart';

class LogManager {
  LogManager._();

  static final instance = LogManager._();

  int maxLogsCount = CRLoggerHelper.instance.maxLogsCount;

  final localLogs = StreamController<LogBean>.broadcast();

  final logDebug = <LogBean>[];
  final logInfo = <LogBean>[];
  final logError = <LogBean>[];

  List<LogBean> logDebugDB = [];
  List<LogBean> logInfoDB = [];
  List<LogBean> logErrorDB = [];

  final _provider = SqfliteProvider.instance;
  final _useDB = CRLoggerHelper.instance.useDB;
  final _httpMng = HttpLogManager.instance;

  Function? onDebugUpdate;
  Function? onInfoUpdate;
  Function? onErrorUpdate;
  Function? onAllUpdate;

  Future<void> loadLogsFromDB({bool getWithCurrentLogs = false}) =>
      _filterLogByType(getWithCurrentLogs: getWithCurrentLogs);

  Future<void> cleanDebug() async {
    await _clearLogs(LogType.debug);
    onDebugUpdate?.call();
  }

  Future<void> cleanInfo() async {
    await _clearLogs(LogType.info);
    onInfoUpdate?.call();
  }

  Future<void> cleanError() async {
    await _clearLogs(LogType.error);
    onErrorUpdate?.call();
  }

  Future<void> clean({bool cleanDB = false}) async {
    if (cleanDB && _useDB) {
      await deleteAllLogs();
    }
    await _httpMng.cleanAllLogs(cleanDB: cleanDB);

    logDebug.clear();
    logInfo.clear();
    logError.clear();
    onAllUpdate?.call();
  }

  Future<void> addDebug(LogBean log) async {
    await _add(
      log,
      logDebug,
    );
    onDebugUpdate?.call();
    onAllUpdate?.call();
  }

  Future<void> addInfo(LogBean log) async {
    await _add(
      log,
      logInfo,
    );
    onInfoUpdate?.call();
    onAllUpdate?.call();
  }

  Future<void> addError(LogBean log) async {
    await _add(
      log,
      logError,
    );
    onErrorUpdate?.call();
    onAllUpdate?.call();
  }

  void updateDebug(Function onUpdated) {
    onUpdated();
  }

  void updateInfo(Function onUpdated) {
    onUpdated();
  }

  void updateError(Function onUpdated) {
    onUpdated();
  }

  Future<void> saveLog(LogBean log) => _provider.saveLog(log);

  Future<void> deleteAllLogs() async {
    await _provider.deleteAllLogs();
    _clearAllDBLogs();
  }

  Future<void> _add(
    LogBean log,
    List<LogBean> logs,
  ) async {
    if (logs.length >= maxLogsCount) {
      logs.removeAt(0);
    }
    localLogs.add(log);
    logs.add(log);
    if (_useDB) {
      await saveLog(log);
    }
  }

  Future<void> _filterLogByType({bool getWithCurrentLogs = false}) async {
    if (_useDB) {
      _clearAllDBLogs();
      final logs = await _provider.getAllSavedLogs();
      final keysD = <String>[...logDebug.map((e) => e.id)];
      final keysI = <String>[...logInfo.map((e) => e.id)];
      final keysE = <String>[...logError.map((e) => e.id)];

      for (final log in logs) {
        final logType = log.type;

        switch (logType) {
          case LogType.http:
            break;
          case LogType.debug:
            if (!keysD.contains(log.id) || getWithCurrentLogs) {
              logDebugDB.add(log);
            }
            break;
          case LogType.info:
            if (!keysI.contains(log.id) || getWithCurrentLogs) {
              logInfoDB.add(log);
            }
            break;
          case LogType.error:
            if (!keysE.contains(log.id) || getWithCurrentLogs) {
              logErrorDB.add(log);
            }
            break;
          default:
            break;
        }
      }

      logDebugDB = _sortLogsByTime(logDebugDB);
      logInfoDB = _sortLogsByTime(logInfoDB);
      logErrorDB = _sortLogsByTime(logErrorDB);
    }
  }

  Future<void> _clearLogs(LogType type) async {
    if (LogsModeController.instance.logMode.value ==
        LogsMode.fromCurrentSession) {
      _clearLogsByType(type);
    } else if (_useDB) {
      await _clearDBLogsByType(type);
    }
  }

  void _clearLogsByType(LogType type) {
    switch (type) {
      case LogType.http:
        break;
      case LogType.debug:
        logDebug.clear();
        break;
      case LogType.info:
        logInfo.clear();
        break;
      case LogType.error:
        logError.clear();
        break;
    }
  }

  Future<void> _clearDBLogsByType(LogType type) async {
    switch (type) {
      case LogType.http:
        break;
      case LogType.debug:
        await _deleteSeveralLogs(logDebugDB);
        logDebugDB.clear();
        break;
      case LogType.info:
        await _deleteSeveralLogs(logInfoDB);
        logInfoDB.clear();
        break;
      case LogType.error:
        await _deleteSeveralLogs(logErrorDB);
        logErrorDB.clear();
        break;
    }
  }

  void _clearAllDBLogs() {
    logDebugDB.clear();
    logInfoDB.clear();
    logErrorDB.clear();
  }

  Future<void> _deleteSeveralLogs(List<LogBean> logs) =>
      _provider.deleteLogs(logs);

  List<LogBean> _sortLogsByTime(List<LogBean> logs) {
    logs.sort((a, b) => a.time.compareTo(b.time));

    return logs;
  }
}
