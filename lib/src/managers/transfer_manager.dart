import 'dart:io';

import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/cr_logger_helper.dart';
import 'package:cr_logger/src/js/console_output_worker.dart';
import 'package:cr_logger/src/js/scripts.dart';
import 'package:cr_logger/src/managers/log_manager.dart';
import 'package:cr_logger/src/utils/html_stub.dart'
    if (dart.library.js) 'dart:html' as html;
import 'package:cr_logger/src/utils/parsers/isolate_parser.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// This manager was made for export and import logs.
class TransferManager {
  final _httpMng = HttpLogManager.instance;
  final _logMng = LogManager.instance;

  final _useDB = CRLoggerHelper.instance.useDB;
  final _parser = IsolateParser();

  Future<void> createJsonFileAndShare() async {
    final json = await _parser.encode(await _toJson());

    if (kIsWeb) {
      final src = html.ScriptElement()
        ..text = downloadLogsWebScript
        ..defer = true;
      html.document.body?.append(src);
      downloadLogsWeb('${CRLoggerInitializer.instance.logFileName}.json', json);
      src.remove();
    } else {
      if (CRLoggerInitializer.instance.onShareLogsFile == null) {
        return;
      }

      final tempDir = await getTemporaryDirectory();

      final path =
          '${tempDir.path}/${CRLoggerInitializer.instance.logFileName}.json';
      final file = await File(path).create();
      await file.writeAsString(json);
      CRLoggerInitializer.instance.onShareLogsFile?.call(path);
    }
  }

  Future<void> createLogsFromJsonFile(File file) async {
    final json = await _parser.decode(await file.readAsString());

    await _logMng.clean();
    _setLogsFromJson(json);
    _httpMng.update();
    _logMng.onAllUpdate?.call();
  }

  Future<void> createLogsFromJson(Map<String, dynamic> json) async {
    await _logMng.clean();
    _setLogsFromJson(json);
    _httpMng.update();
    _logMng.onAllUpdate?.call();
  }

  Future<Map<String, dynamic>> _toJson() async {
    final httpLog = <String, dynamic>{};

    if (_useDB) {
      await _logMng.loadLogsFromDB(getWithCurrentLogs: true);
      await _httpMng.loadLogsFromDB(getWithCurrentLogs: true);
      for (final element in _httpMng.logsFromDB) {
        httpLog[element.key.toString()] = element.toJson();
      }
    } else {
      for (final element in _httpMng.logMap.entries) {
        httpLog[element.key] = element.value.toJson();
      }
    }

    return {
      'http': httpLog,
      'debug': _logModelsToJson(_useDB ? _logMng.logDebugDB : _logMng.logDebug),
      'info': _logModelsToJson(_useDB ? _logMng.logInfoDB : _logMng.logInfo),
      'error': _logModelsToJson(_useDB ? _logMng.logErrorDB : _logMng.logError),
    };
  }

  void _setLogsFromJson(Map<String, dynamic> json) {
    if (json['http'] != null) {
      final httpLogs = json['http'] as Map<String, dynamic>;
      for (final element in httpLogs.entries) {
        _httpMng.logMap[element.key] = HttpBean.fromJson(element.value);
        _httpMng.keys.add(element.key);
      }
    }
    final debug = json['debug'];
    final info = json['info'];
    final error = json['error'];
    if (debug is List) {
      _logMng.logDebug.addAll(_logModelsFromJson(
        debug.map((e) => e as Map<String, dynamic>).toList(),
      ));
    }
    if (info is List) {
      _logMng.logInfo.addAll(_logModelsFromJson(
        info.map((e) => e as Map<String, dynamic>).toList(),
      ));
    }
    if (error is List) {
      _logMng.logError.addAll(_logModelsFromJson(
        error.map((e) => e as Map<String, dynamic>).toList(),
      ));
    }
  }

  List<Map<String, dynamic>> _logModelsToJson(List<LogBean> logs) =>
      logs.map((item) => item.toJson()).toList().reversed.toList();

  List<LogBean> _logModelsFromJson(List<Map<String, dynamic>> json) {
    final listOfLogBean = <LogBean>[];

    for (final logBean in json) {
      listOfLogBean.add(LogBean.fromJson(logBean));
    }

    return listOfLogBean;
  }
}
