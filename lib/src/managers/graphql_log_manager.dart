import 'dart:collection';

import 'package:cr_logger/src/controllers/logs_mode_controller.dart';
import 'package:cr_logger/src/cr_logger_helper.dart';
import 'package:cr_logger/src/data/bean/gql_bean.dart';
import 'package:cr_logger/src/data/bean/graphql/graphql_error_bean.dart';
import 'package:cr_logger/src/data/bean/graphql/graphql_request_bean.dart';
import 'package:cr_logger/src/data/bean/graphql/graphql_response_bean.dart';
import 'package:cr_logger/src/providers/sqflite_provider.dart';
import 'package:cr_logger/src/utils/pretty_cr_logger/pretty_cr_logger.dart';

final class GraphQLLogManager {
  GraphQLLogManager._();

  static GraphQLLogManager instance = GraphQLLogManager._();

  final _prettyCRLogger = PrettyCRLogger();

  final _provider = SqfliteProvider.instance;
  final _useDB = CRLoggerHelper.instance.useDB;
  final _isPrintLogs = CRLoggerHelper.instance.printLogs;

  LinkedHashMap<String, GQLBean> logMap = LinkedHashMap<String, GQLBean>();

  List<GQLBean> logsFromDB = [];
  int maxLogsCount = CRLoggerHelper.instance.maxLogsCount;

  List<String> keys = <String>[];

  Function? updateGQLPage;
  Function? updateSearchGQLPage;

  void onRequest(GraphQLRequestBean request) {
    if (_isPrintLogs) {
      _prettyCRLogger.onRequest(request);
    }

    final key = request.id.toString();
    if (!keys.contains(key)) {
      if (logMap.length >= maxLogsCount) {
        logMap.remove(keys.last);
        keys.removeLast();
      }
      keys.insert(0, key);
      final bean = logMap.putIfAbsent(key, () => GQLBean(request: request));
      final id = request.id;
      bean.key = id;
      saveGQLBean(bean);
    }

    updateGQLPage?.call();
    updateSearchGQLPage?.call();
  }

  void onResponse(GraphQLResponseBean response) {
    if (_isPrintLogs) {
      _prettyCRLogger.onResponse(response);
    }

    final key = response.id.toString();
    if (logMap.containsKey(key)) {
      logMap.update(key, (value) {
        final respTime = response.responseTime.millisecondsSinceEpoch;
        final reqTime = value.request?.requestTime.millisecondsSinceEpoch;
        if (reqTime != null) {
          response.duration = respTime - reqTime;
        }
        value
          ..response = response
          ..key = response.id;
        updateGQLBean(value);

        return value;
      });
      updateGQLPage?.call();
      updateSearchGQLPage?.call();
    }
  }

  void onError(GraphqlErrorBean error) {
    if (_isPrintLogs) {
      _prettyCRLogger.onError(error);
    }

    final key = error.id.toString();
    if (logMap.containsKey(key)) {
      logMap.update(key, (value) {
        final errTime = error.errorTime?.millisecondsSinceEpoch;
        final reqTime = value.request?.requestTime.millisecondsSinceEpoch;
        if (errTime != null && reqTime != null) {
          error.duration = errTime - reqTime;
        }
        value
          ..error = error
          ..key = error.id;
        updateGQLBean(value);

        return value;
      });

      updateGQLPage?.call();
      updateSearchGQLPage?.call();
    }
  }

  Future<void> saveGQLBean(GQLBean bean) async {
    // if (_useDB) {
    //   await _provider.insertGQLBean(bean);
    // }
  }

  Future<void> updateGQLBean(GQLBean bean) async {
    // if (_useDB) {
    //   await _provider.updateGQLBean(bean);
    // }
  }

  Future<void> cleanGQLLogs() async {
    await _deleteGQLLogs();
    updateSearchGQLPage?.call();
    updateGQLPage?.call();
  }

  Future<void> cleanAllLogs({bool clearDB = false}) async {
    if (LogsModeController.instance.isFromCurrentSession && !clearDB) {
      logMap.clear();
      keys.clear();
    } else if (_useDB && clearDB) {
      logsFromDB.clear();
      // await _provider.deleteAllHttpLogs();
    }
  }

  List<GQLBean> logValues() {
    return logMap.values.toList();
  }

  List<GQLBean> sortLogsByTime(List<GQLBean> logs) {
    logs.sort((a, b) {
      final aDate = a.request?.requestTime;
      final bDate = b.request?.requestTime;

      if (aDate != null && bDate != null) {
        return aDate.compareTo(bDate);
      }

      return 0;
    });

    return logs;
  }

  LinkedHashMap<String, GQLBean> sortLogsMapByTime(
    LinkedHashMap<String, GQLBean> logs,
  ) {
    return LinkedHashMap.fromEntries(
      logs.entries.toList()
        ..sort((a, b) {
          final aDate = a.value.request?.requestTime;
          final bDate = b.value.request?.requestTime;

          if (aDate != null && bDate != null) {
            return aDate.compareTo(bDate);
          }

          return 0;
        }),
    );
  }

  Future<void> removeLog(GQLBean httpLog) async {
    logMap.removeWhere((key, element) =>
        element.request?.id == httpLog.request?.id &&
        element.request?.id != null);

    if (_useDB) {
      logsFromDB.removeWhere((element) =>
          element.request?.id == httpLog.request?.id &&
          element.request?.id != null);

      final logs = await _provider.getAllSavedHttpLogs();
      final savedLogs = logs
          .where((element) =>
              element.request?.id == httpLog.request?.id &&
              element.request?.id != null)
          .toList();
      await _provider.deleteHttpLogs(savedLogs);
    }

    updateGQLPage?.call();
    updateSearchGQLPage?.call();
  }

  Future<void> _deleteGQLLogs() async {
    if (LogsModeController.instance.isFromCurrentSession) {
      logMap.clear();
      keys.clear();
    } else if (_useDB) {
      // await _provider.deleteHttpLogs(logsFromDB);
      logsFromDB.clear();
    }
  }
}
