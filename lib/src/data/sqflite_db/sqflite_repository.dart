import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/cr_logger_helper.dart';
import 'package:cr_logger/src/data/sqflite_db/entities/http_entity.dart';
import 'package:cr_logger/src/data/sqflite_db/entities/log_entity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final class SqfliteRepository {
  SqfliteRepository._();

  /// HTTP Table
  static const _kHTTPLogTable = 'HTTP_Logs';
  static const _kCreateHTTPLogTable =
      'CREATE TABLE $_kHTTPLogTable(key INTEGER PRIMARY KEY, request TEXT, response TEXT, error TEXT)';

  /// Log Table
  static const _kLogsTable = 'Logs';
  static const _kCreateLogTable =
      'CREATE TABLE $_kLogsTable(key INTEGER PRIMARY KEY AUTOINCREMENT, id TEXT, message TEXT, time TEXT, stacktrace TEXT, data TEXT, type TEXT)';

  static const _kVersion = 1;

  static final instance = SqfliteRepository._();

  final _maxLogsCount = CRLoggerHelper.instance.maxDBLogsCount;

  late final Database _database;

  Future<void> initDB() async {
    final pathDB = await getDatabasesPath();
    final path = join(pathDB, 'cr_logger_logs.db');
    _database = await openDatabase(
      path,
      onCreate: (database, version) async {
        await database.execute(_kCreateLogTable);
        await database.execute(_kCreateHTTPLogTable);
      },
      version: _kVersion,
    );
  }

  /// HTTP Logs

  /// When a http log is saved, there is a check that there are more http logs than the maximum number,
  /// then the earliest log is deleted.
  Future<void> saveHTTPLog(HttpEntity log) async {
    await _database.insert(
      _kHTTPLogTable,
      log.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await _limitedHttpLogs();
  }

  Future<void> updateHTTPLog(HttpEntity log) async {
    await _database.update(
      _kHTTPLogTable,
      log.toJson(),
      where: 'key = ?',
      whereArgs: [log.key],
    );
    await _limitedHttpLogs();
  }

  Future<List<HttpEntity>> getAllHttpLogs() async {
    final response = await _database.query(_kHTTPLogTable);

    return response.map(HttpEntity.fromJson).toList();
  }

  Future<void> deleteAllHttpLogs() async {
    await _database.delete(_kHTTPLogTable);
  }

  Future<void> deleteHttpLogs(List<int> keys) async {
    for (final key in keys) {
      await _database.delete(
        _kHTTPLogTable,
        where: 'key = ?',
        whereArgs: [key],
      );
    }
  }

  /// Logs

  /// When a log is saved, there is a check that there are more logs than the maximum number,
  /// then the earliest log is deleted.
  Future<void> saveLog(LogEntity log) async {
    await _database.insert(
      _kLogsTable,
      log.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await _limitedLogs(log.type);
  }

  Future<List<LogEntity>> getAllLogs() async {
    final response = await _database.query(_kLogsTable);

    return response.map(LogEntity.fromJson).toList();
  }

  Future<void> deleteAllLogs() async {
    await _database.delete(_kLogsTable);
  }

  Future<void> deleteLogs(List<int> keys) async {
    for (final key in keys) {
      await _database.delete(
        _kLogsTable,
        where: 'key = ?',
        whereArgs: [key],
      );
    }
  }

  Future<void> _limitedHttpLogs() async {
    final logs = await getAllHttpLogs();
    if (logs.length > _maxLogsCount) {
      final key = logs.first.key;
      if (key != null) {
        await _database.delete(
          _kHTTPLogTable,
          where: 'key = ?',
          whereArgs: [key],
        );
      }
    }
  }

  Future<void> _limitedLogs(LogType logType) async {
    final logs = <LogEntity>[];
    await _database.query(
      _kLogsTable,
      where: 'type = ?',
      whereArgs: [logType.name],
    ).then(
          (value) => value.map((e) => logs.add(LogEntity.fromJson(e))).toList(),
    );
    if (logs.length > _maxLogsCount) {
      final key = logs.first.key;
      if (key != null) {
        await _database.delete(
          _kLogsTable,
          where: 'key = ?',
          whereArgs: [key],
        );
      }
    }
  }
}
