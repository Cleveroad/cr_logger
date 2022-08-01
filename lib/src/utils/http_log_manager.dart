import 'dart:collection';

import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/utils/pretty_cr_logger.dart';

class HttpLogManager {
  HttpLogManager._();

  static HttpLogManager instance = HttpLogManager._();

  final _prettyCRLogger = PrettyCRLogger();

  LinkedHashMap<String, HttpBean> logMap = LinkedHashMap<String, HttpBean>();

  int logSize = 50;

  List<String> keys = <String>[];

  Function? onUpdate;

  void onError(ErrorBean err) {
    _prettyCRLogger.onError(err);
    final key = err.id.toString();
    if (logMap.containsKey(key)) {
      logMap.update(key, (value) {
        final errTime = err.time?.millisecondsSinceEpoch;
        final reqTime = value.request?.requestTime?.millisecondsSinceEpoch;
        if (errTime != null && reqTime != null) {
          err.duration = errTime - reqTime;
        }
        value.error = err;

        return value;
      });

      onUpdate?.call();
    }
  }

  void onRequest(RequestBean options) {
    _prettyCRLogger.onRequest(options);
    final key = options.id.toString();
    if (!keys.contains(key)) {
      if (logMap.length >= logSize) {
        logMap.remove(keys.last);
        keys.removeLast();
      }
      keys.insert(0, key);
      logMap.putIfAbsent(key, () => HttpBean(request: options));
      onUpdate?.call();
    }
  }

  void onResponse(ResponseBean response) {
    _prettyCRLogger.onResponse(response);
    final key = response.id.toString();
    if (logMap.containsKey(key)) {
      logMap.update(key, (value) {
        final respTime = response.responseTime?.millisecondsSinceEpoch;
        final requestTime = value.request?.requestTime?.millisecondsSinceEpoch;
        if (respTime != null && requestTime != null) {
          response.duration = respTime - requestTime;
        }
        value.response = response;

        return value;
      });
      onUpdate?.call();
    }
  }

  void clear() {
    logMap.clear();
    keys.clear();
    onUpdate?.call();
  }

  void update() {
    onUpdate?.call();
  }
}
