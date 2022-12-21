import 'dart:collection';

import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/constants.dart';
import 'package:cr_logger/src/controllers/logs_mode_controller.dart';
import 'package:cr_logger/src/cr_logger_helper.dart';
import 'package:cr_logger/src/providers/sqflite_provider.dart';
import 'package:cr_logger/src/utils/pretty_cr_logger.dart';

class HttpLogManager {
  HttpLogManager._();

  static HttpLogManager instance = HttpLogManager._();

  final _prettyCRLogger = PrettyCRLogger();
  final _provider = SqfliteProvider.instance;
  final _useDB = CRLoggerHelper.instance.useDB;
  final _printLogs = CRLoggerHelper.instance.printLogs;

  LinkedHashMap<String, HttpBean> logMap = LinkedHashMap<String, HttpBean>();

  List<HttpBean> logsFromDB = [];
  int maxLogsCount = CRLoggerHelper.instance.maxLogsCount;

  List<String> keys = <String>[];

  Function? onUpdate;

  void onError(ErrorBean err) {
    if (_printLogs) {
      _prettyCRLogger.onError(err);
    }
    final key = err.id.toString();
    if (logMap.containsKey(key)) {
      logMap.update(key, (value) {
        final errTime = err.time?.millisecondsSinceEpoch;
        final reqTime = value.request?.requestTime?.millisecondsSinceEpoch;
        if (errTime != null && reqTime != null) {
          err.duration = errTime - reqTime;
        }
        value
          ..error = err
          ..key = err.id;
        updateHttpLog(value);

        return value;
      });

      onUpdate?.call();
    }
  }

  void onRequest(RequestBean options) {
    if (_printLogs) {
      _prettyCRLogger.onRequest(options);
    }
    final key = options.id.toString();
    if (!keys.contains(key)) {
      if (logMap.length >= maxLogsCount) {
        logMap.remove(keys.last);
        keys.removeLast();
      }
      keys.insert(0, key);
      final value = logMap.putIfAbsent(key, () => HttpBean(request: options));
      final id = options.id;
      if (id != null) {
        value.key = id;
        saveHttpLog(value);
      }

      onUpdate?.call();
    }
  }

  Future<void> onResponse(ResponseBean response) async {
    if (_printLogs) {
      await _prettyCRLogger.onResponse(response);
    }
    final key = response.id.toString();
    if (logMap.containsKey(key)) {
      logMap.update(key, (value) {
        final respTime = response.responseTime?.millisecondsSinceEpoch;
        final requestTime = value.request?.requestTime?.millisecondsSinceEpoch;
        if (respTime != null && requestTime != null) {
          response.duration = respTime - requestTime;
        }
        value.response = response;
        final id = response.id;
        if (id != null) {
          value.key = id;
          updateHttpLog(value);
        }

        return value;
      });
      onUpdate?.call();
    }
  }

  Future<void> cleanAllLogs({bool cleanDB = false}) async {
    await _deleteAllHttpLogs(clearDB: cleanDB);
    onUpdate?.call();
  }

  Future<void> cleanHTTP() async {
    await _deleteHttpLogs();
    onUpdate?.call();
  }

  void update() {
    onUpdate?.call();
  }

  Future<void> loadLogsFromDB({bool getWithCurrentLogs = false}) async {
    if (_useDB) {
      logsFromDB.clear();
      logsFromDB = await _provider.getAllSavedHttpLogs();
      if (!getWithCurrentLogs) {
        for (final key in keys) {
          logsFromDB.removeWhere((element) => element.key.toString() == key);
        }
      }
      _sortLogsByTime();
    }
  }

  // TODO: change it later
  List<HttpBean> logMapToList() {
    final logModelList = <HttpBean>[];
    logMap.forEach((key, jsonLog) {
      logModelList.add(jsonLog);
    });

    return logModelList;
  }

  Set<String> getAllRequests() {
    final _logsMode = LogsModeController.instance.logMode.value;
    final logs =
        _logsMode == LogsMode.fromCurrentSession ? logMapToList() : logsFromDB;

    return logs
        .map((log) {
          final url = log.request?.url;
          if (url != null) {
            final path = Uri.parse(url).path;

            return path;
          }

          return null;
        })
        .whereType<String>()
        .toList()
        .reversed
        .take(kDefaultOfUrlCount)
        .toSet();
  }

  Future<void> saveHttpLog(HttpBean jsonLog) async {
    if (_useDB) {
      await _provider.saveHttpLog(jsonLog);
    }
  }

  Future<void> updateHttpLog(HttpBean jsonLog) async {
    if (_useDB) {
      await _provider.updateHttpLog(jsonLog);
    }
  }

  Future<void> deleteAllHttpLogs() => _provider.deleteAllHttpLogs();

  void _sortLogsByTime() {
    logsFromDB.sort((a, b) {
      final aDate = a.request?.requestTime;
      final bDate = b.request?.requestTime;

      if (aDate != null && bDate != null) {
        return aDate.compareTo(bDate);
      }

      return 0;
    });
  }

  Future<void> _deleteAllHttpLogs({bool clearDB = false}) async {
    if (LogsModeController.instance.logMode.value ==
            LogsMode.fromCurrentSession &&
        !clearDB) {
      logMap.clear();
      keys.clear();
    } else if (_useDB && clearDB) {
      logsFromDB.clear();
      await _provider.deleteAllHttpLogs();
    }
  }

  Future<void> _deleteHttpLogs() async {
    if (LogsModeController.instance.logMode.value ==
        LogsMode.fromCurrentSession) {
      logMap.clear();
      keys.clear();
    } else if (_useDB) {
      await _provider.deleteHttpLogs(logsFromDB);
      logsFromDB.clear();
    }
  }
}
