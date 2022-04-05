import 'dart:async';
import 'dart:convert' as conv;
import 'dart:io';

import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/js/console_output_worker.dart';
import 'package:cr_logger/src/js/scripts.dart';
import 'package:cr_logger/src/utils/html_stub.dart'
    if (dart.library.js) 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class LocalLogManager {
  LocalLogManager._();

  static final instance = LocalLogManager._();

  int logSize = 50;

  final localLogs = StreamController<LogBean>.broadcast();

  final logDebug = <LogBean>[];
  final logInfo = <LogBean>[];
  final logError = <LogBean>[];

  Function? onDebugUpdate;
  Function? onInfoUpdate;
  Function? onErrorUpdate;
  Function? onAllUpdate;

  void cleanDebug() {
    logDebug.clear();
  }

  void cleanInfo() {
    logInfo.clear();
  }

  void cleanError() {
    logError.clear();
  }

  void clean() {
    HttpLogManager.instance.keys.clear();
    HttpLogManager.instance.logMap.clear();
    logDebug.clear();
    logInfo.clear();
    logError.clear();
    onDebugUpdate?.call();
    onInfoUpdate?.call();
    onErrorUpdate?.call();
  }

  void addDebug(LogBean log) {
    _add(log, logDebug);
    onDebugUpdate?.call();
    onAllUpdate?.call();
  }

  void addInfo(LogBean log) {
    _add(log, logInfo);
    onInfoUpdate?.call();
    onAllUpdate?.call();
  }

  void addError(LogBean log) {
    _add(log, logError);
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

  Map<String, dynamic> toJson() {
    final httpLog = <String, dynamic>{};

    for (final element in HttpLogManager.instance.logMap.entries) {
      httpLog[element.key] = element.value.toJson();
    }

    return {
      'http': httpLog,
      'debug': logModelsToJson(logDebug),
      'info': logModelsToJson(logInfo),
      'error': logModelsToJson(logError),
    };
  }

  void setLogsFromJson(Map<String, dynamic> json) {
    if (json['http'] != null) {
      final httpLogs = json['http'] as Map<String, dynamic>;
      for (final element in httpLogs.entries) {
        HttpLogManager.instance.logMap[element.key] =
            HttpBean.fromJson(element.value);
        HttpLogManager.instance.keys.add(element.key);
      }
    }
    final debug = json['debug'];
    final info = json['info'];
    final error = json['error'];
    if (debug is List) {
      logDebug.addAll(logModelsFromJson(
        debug.map((e) => e as Map<String, dynamic>).toList(),
      ));
    }
    if (info is List) {
      logInfo.addAll(logModelsFromJson(
        info.map((e) => e as Map<String, dynamic>).toList(),
      ));
    }
    if (error is List) {
      logError.addAll(logModelsFromJson(
        error.map((e) => e as Map<String, dynamic>).toList(),
      ));
    }
  }

  List<Map<String, dynamic>> logModelsToJson(List<LogBean> logs) =>
      logs.map((item) => item.toJson()).toList().reversed.toList();

  List<LogBean> logModelsFromJson(List<Map<String, dynamic>> json) {
    final listOfLogBean = <LogBean>[];

    for (final logBean in json) {
      listOfLogBean.add(LogBean.fromJson(logBean));
    }

    return listOfLogBean;
  }

  Future<void> createJsonFileAndShare() async {
    final json = conv.json.encode(toJson());

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
    final json = conv.json.decode(await file.readAsString());

    clean();
    setLogsFromJson(json);
    HttpLogManager.instance.update();
  }

  Future<void> createLogsFromJson(Map<String, dynamic> json) async {
    clean();
    setLogsFromJson(json);
    HttpLogManager.instance.update();
  }

  void _add(LogBean log, List<LogBean> logs) {
    if (logs.length >= logSize) {
      logs.removeAt(0);
    }
    localLogs.add(log);
    logs.add(log);
  }
}
