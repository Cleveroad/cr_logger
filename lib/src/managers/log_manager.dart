import 'dart:async';

import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/controllers/logs_mode_controller.dart';
import 'package:cr_logger/src/cr_logger_helper.dart';
import 'package:cr_logger/src/providers/sqflite_provider.dart';
import 'package:flutter/cupertino.dart';

final class LogManager {
  LogManager._();

  static final instance = LogManager._();

  int maxLogsCount = CRLoggerHelper.instance.maxLogsCount;

  final localLogs = StreamController<LogBean>.broadcast();

  List<LogBean> logDebug = [];
  List<LogBean> logInfo = [];
  List<LogBean> logError = [];

  List<LogBean> logDebugDB = [];
  List<LogBean> logInfoDB = [];
  List<LogBean> logErrorDB = [];

  final _provider = SqfliteProvider.instance;
  final _useDB = CRLoggerHelper.instance.useDB;
  final _httpMng = HttpLogManager.instance;

  ValueNotifier<LogBean?> logToastNotifier = ValueNotifier<LogBean?>(null);

  Function? onDebugUpdate;
  Function? onInfoUpdate;
  Function? onErrorUpdate;
  Function? onSearchPageUpdate;
  Function? onAllUpdate;
  Function? onLogsClear;
  ValueChanged<LogBean>? onLogAdded;

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
    await _add(log, logDebug);
    onDebugUpdate?.call();
    onAllUpdate?.call();
    onSearchPageUpdate?.call();
  }

  Future<void> addInfo(LogBean log) async {
    await _add(log, logInfo);
    onInfoUpdate?.call();
    onAllUpdate?.call();
    onSearchPageUpdate?.call();
  }

  Future<void> addError(LogBean log) async {
    await _add(log, logError);
    onErrorUpdate?.call();
    onAllUpdate?.call();
    onSearchPageUpdate?.call();
  }

  Future<void> saveLog(LogBean log) => _provider.saveLog(log);

  Future<void> deleteAllLogs() async {
    await _provider.deleteAllLogs();
    _clearAllDBLogs();
  }

  Future<void> removeLog(LogBean log) async {
    logDebug.removeWhere((element) => element.id == log.id);
    logInfo.removeWhere((element) => element.id == log.id);
    logError.removeWhere((element) => element.id == log.id);

    if (_useDB) {
      logDebugDB.removeWhere((element) => element.id == log.id);
      logInfoDB.removeWhere((element) => element.id == log.id);
      logErrorDB.removeWhere((element) => element.id == log.id);
      await _deleteLogFromDB(log);
    }

    onAllUpdate?.call();
    onSearchPageUpdate?.call();
  }

  Future<void> addLogToDB(LogBean log) async {
    if (_useDB) {
      await saveLog(log);
    }
  }

  void addLogToListByType(LogType type, LogBean log) {
    switch (type) {
      case LogType.http:
        break;
      case LogType.debug:
        logDebug.insert(0, log);
        logDebug = sortLogsByTime(logDebug);
        break;
      case LogType.info:
        logInfo.insert(0, log);
        logInfo = sortLogsByTime(logInfo);
        break;
      case LogType.error:
        logError.insert(0, log);
        logError = sortLogsByTime(logError);
        break;
    }

    onAllUpdate?.call();
    onSearchPageUpdate?.call();
  }

  void addLogToDBListByType(LogType type, LogBean log) {
    switch (type) {
      case LogType.http:
        break;
      case LogType.debug:
        logDebugDB.insert(0, log);
        logDebugDB = sortLogsByTime(logDebugDB);
        break;
      case LogType.info:
        logInfoDB.insert(0, log);
        logInfoDB = sortLogsByTime(logInfoDB);
        break;
      case LogType.error:
        logErrorDB.insert(0, log);
        logErrorDB = sortLogsByTime(logErrorDB);
        break;
    }

    onAllUpdate?.call();
    onSearchPageUpdate?.call();
  }

  List<LogBean> sortLogsByTime(List<LogBean> logs) {
    logs.sort((a, b) => a.time.compareTo(b.time));

    return logs;
  }

  /// If the number of logs exceeds the limit, a shift happens.
  /// The first item is deleted and a new one is added to the end of the list.
  ///
  /// When displayed, the list is inverted, thus displaying the new logs at
  /// the beginning
  Future<void> _add(
    LogBean log,
    List<LogBean> logs,
  ) async {
    if (logs.length >= maxLogsCount) {
      logs.removeAt(0);
    }

    logs.add(log);
    localLogs.add(log);

    /// Display snack bar
    if (log.showToast) {
      onLogAdded?.call(log);
    }

    if (_useDB) {
      await saveLog(log);
    }
  }

  Future<void> _deleteLogFromDB(LogBean log) async {
    final logs = await _provider.getAllSavedLogs();
    final savedLogs = logs.where((element) => element.id == log.id).toList();
    await _provider.deleteLogs(savedLogs);
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

      logDebugDB = sortLogsByTime(logDebugDB);
      logInfoDB = sortLogsByTime(logInfoDB);
      logErrorDB = sortLogsByTime(logErrorDB);
    }
  }

  Future<void> _clearLogs(LogType type) async {
    if (LogsModeController.instance.isFromCurrentSession) {
      _clearLogsByType(type);
    } else if (_useDB) {
      await _clearDBLogsByType(type);
    }

    onLogsClear?.call();
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
}
