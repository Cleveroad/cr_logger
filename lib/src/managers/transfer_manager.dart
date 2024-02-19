import 'dart:io';

import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/cr_logger_helper.dart';
import 'package:cr_logger/src/data/sqflite_db/converters/http_enitity_converter.dart';
import 'package:cr_logger/src/data/sqflite_db/converters/log_entity_converters.dart';
import 'package:cr_logger/src/data/sqflite_db/entities/http_entity.dart';
import 'package:cr_logger/src/data/sqflite_db/entities/log_entity.dart';
import 'package:cr_logger/src/js/console_output_worker.dart';
import 'package:cr_logger/src/js/scripts.dart';
import 'package:cr_logger/src/managers/log_manager.dart';
import 'package:cr_logger/src/utils/html_stub.dart'
    if (dart.library.js) 'dart:html' as html;
import 'package:cr_logger/src/utils/parsers/isolate_parser.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// This manager was made for export and import logs.
final class TransferManager {
  final _httpMng = HttpLogManager.instance;
  final _logMng = LogManager.instance;

  final _useDB = CRLoggerHelper.instance.useDB;
  final _parser = IsolateParser();

  final _logCnv = LogEntityConverter();
  final _httpCnv = HttpEntityConverter();

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
    await _setLogsFromJson(json);
    _httpMng.update();
    _logMng.onAllUpdate?.call();
  }

  /// Works only in Web.
  Future<void> createLogsFromJson(Map<String, dynamic> json) async {
    await _logMng.clean();
    await _setLogsFromJson(json);
    _httpMng.update();
    _logMng.onAllUpdate?.call();
  }

  Future<List<Map<String, dynamic>>> _httpLogsToJson(
    List<HttpBean> logs,
  ) async {
    final httpLogs = <Map<String, dynamic>>[];
    for (final log in logs) {
      final httpEntity = await _httpCnv.outToIn(log);
      httpLogs.add(httpEntity.toJson());
    }

    return httpLogs;
  }

  Future<Map<String, dynamic>> _toJson() async {
    if (_useDB) {
      await _logMng.loadLogsFromDB(getWithCurrentLogs: true);
      await _httpMng.loadLogsFromDB(getWithCurrentLogs: true);
      await _httpLogsToJson(_httpMng.logsFromDB);
    }

    return {
      'http': await _httpLogsToJson(
        _useDB
            ? _httpMng.logsFromDB
            : _httpMng.logMap.entries.map((e) => e.value).toList(),
      ),
      'debug': await _logModelsToJson(
        _useDB ? _logMng.logDebugDB : _logMng.logDebug,
      ),
      'info': await _logModelsToJson(
        _useDB ? _logMng.logInfoDB : _logMng.logInfo,
      ),
      'error': await _logModelsToJson(
        _useDB ? _logMng.logErrorDB : _logMng.logError,
      ),
    };
  }

  Future<void> _setLogsFromJson(Map<String, dynamic> json) async {
    final http = json['http'];
    final debug = json['debug'];
    final info = json['info'];
    final error = json['error'];

    if (http is List) {
      await _httpLogsFromJson(
        http.map((e) => e as Map<String, dynamic>).toList(),
      );
    }
    if (debug is List) {
      _logMng.logDebug.addAll(
        await _logModelsFromJson(
          debug.map((e) => e as Map<String, dynamic>).toList(),
        ),
      );
    }
    if (info is List) {
      _logMng.logInfo.addAll(
        await _logModelsFromJson(
          info.map((e) => e as Map<String, dynamic>).toList(),
        ),
      );
    }
    if (error is List) {
      _logMng.logError.addAll(
        await _logModelsFromJson(
          error.map((e) => e as Map<String, dynamic>).toList(),
        ),
      );
    }
  }

  Future<List<Map<String, dynamic>>> _logModelsToJson(
    List<LogBean> logs,
  ) async {
    final jsonData = <Map<String, dynamic>>[];
    for (final log in logs) {
      final logEntity = await _logCnv.outToIn(log);
      jsonData.add(logEntity.toJson());
    }

    return jsonData.toList();
  }

  Future<List<LogBean>> _logModelsFromJson(
    List<Map<String, dynamic>> json,
  ) async {
    final listOfLogBean = <LogBean>[];

    for (final data in json) {
      final logBean = await _logCnv.inToOut(LogEntity.fromJson(data));
      listOfLogBean.add(logBean);
    }

    return listOfLogBean;
  }

  Future<void> _httpLogsFromJson(List<Map<String, dynamic>> json) async {
    for (final element in json) {
      final httpBean = await _httpCnv.inToOut(HttpEntity.fromJson(element));
      final key = httpBean.key.toString();
      _httpMng.logMap[key] = httpBean;
      _httpMng.keys.add(key);
    }
  }
}
