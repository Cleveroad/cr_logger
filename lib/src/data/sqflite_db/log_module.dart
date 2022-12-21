import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/data/sqflite_db/converters/http_enitity_converter.dart';
import 'package:cr_logger/src/data/sqflite_db/converters/log_entity_converters.dart';
import 'package:cr_logger/src/data/sqflite_db/sqflite_repository.dart';

class LogModule {
  LogModule._();

  static LogModule instance = LogModule._();

  final _httpLogConverter = HttpEntityConverter();
  final _logConverter = LogEntityConverter();

  final _sqlRepository = SqfliteRepository.instance;

  Future<void> init() async {
    await _sqlRepository.initDB();
  }

  /// Http Log
  Future<List<HttpBean>> getAllSavedHttpLogs() async {
    final logs = await _sqlRepository.getAllHttpLogs();
    final logModel = <HttpBean>[];
    for (final log in logs) {
      logModel.add(await _httpLogConverter.inToOut(log));
    }

    return logModel;
  }

  Future<void> saveHttpLog(HttpBean httpLog) async =>
      _sqlRepository.saveHTTPLog(
        await _httpLogConverter.outToIn(httpLog),
      );

  Future<void> updateHttpLog(HttpBean httpLog) async =>
      _sqlRepository.updateHTTPLog(
        await _httpLogConverter.outToIn(httpLog),
      );

  Future<void> deleteAllHttpLogs() => _sqlRepository.deleteAllHttpLogs();

  Future<void> deleteHttpLogs(List<HttpBean> logs) async {
    final ids = logs.map((e) => e.key).whereType<int>().toList();

    return _sqlRepository.deleteHttpLogs(ids);
  }

  /// Logs
  Future<List<LogBean>> getAllSavedLogs() async {
    final logs = await _sqlRepository.getAllLogs();
    final logModel = <LogBean>[];
    for (final log in logs) {
      logModel.add(await _logConverter.inToOut(log));
    }

    return logModel;
  }

  Future<void> saveLog(LogBean log) async => _sqlRepository.saveLog(
        await _logConverter.outToIn(log),
      );

  Future<void> deleteAllLogs() => _sqlRepository.deleteAllLogs();

  Future<void> deleteLogs(List<LogBean> logs) async {
    final ids = logs.map((e) => e.key).whereType<int>().toList();

    return _sqlRepository.deleteLogs(ids);
  }
}
