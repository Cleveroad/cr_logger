import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/data/sqflite_db/log_module.dart';

final class SqfliteProvider {
  SqfliteProvider._();

  static final instance = SqfliteProvider._();

  final _module = LogModule.instance;

  Future<void> init() => _module.init();

  /// HTTP logs
  Future<void> saveHttpLog(HttpBean httpLog) => _module.saveHttpLog(httpLog);

  Future<void> updateHttpLog(HttpBean httpLog) =>
      _module.updateHttpLog(httpLog);

  Future<List<HttpBean>> getAllSavedHttpLogs() => _module.getAllSavedHttpLogs();

  Future<void> deleteAllHttpLogs() => _module.deleteAllHttpLogs();

  Future<void> deleteHttpLogs(List<HttpBean> logs) =>
      _module.deleteHttpLogs(logs);

  /// Logs
  Future<void> saveLog(LogBean log) => _module.saveLog(log);

  Future<List<LogBean>> getAllSavedLogs() => _module.getAllSavedLogs();

  Future<void> deleteAllLogs() => _module.deleteAllLogs();

  Future<void> deleteLogs(List<LogBean> logs) => _module.deleteLogs(logs);
}
