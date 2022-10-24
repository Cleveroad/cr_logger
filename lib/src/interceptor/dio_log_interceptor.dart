import 'dart:io';

import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/cr_logger_helper.dart';
import 'package:dio/dio.dart';

typedef ParserError = Map<String, dynamic> Function(Object? data);

///log Format request time
class DioLogInterceptor implements Interceptor {
  DioLogInterceptor({this.parserError});

  final logManager = HttpLogManager.instance;
  final ParserError? parserError;

  @override
  void onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) {
    if (!CRLoggerHelper.instance.doPrintLogs) {
      return handler.next(err);
    }

    dynamic json;
    try {
      if (err.error is Map) {
        json = err.error;
      } else if (err.error is SocketException) {
        final exception = err.error as SocketException;
        json = {
          'Error': exception.message,
          'OS Error': exception.osError?.message,
          'OS Error code': exception.osError?.errorCode,
          'No internet': _isNetworkError(exception),
        };
      } else if (parserError != null) {
        json = parserError!(err.error);
      } else {
        throw Exception(err);
      }
    } catch (e, _) {
      json = err.error;
    }
    final resOpt = ResponseBean()
      ..id = err.requestOptions.hashCode
      ..responseTime = DateTime.now()
      ..statusCode = err.response?.statusCode ?? 0
      ..url = err.response?.requestOptions.uri.toString()
      ..method = err.response?.requestOptions.method
      ..statusMessage = err.response?.statusMessage
      ..data = err.response?.data
      ..headers = err.response?.headers.map;

    final errOptions = ErrorBean()
      ..id = err.requestOptions.hashCode
      ..errorMessage = err.message
      ..errorData = json
      ..statusCode = err.response?.statusCode
      ..statusMessage = err.response?.statusMessage
      ..baseUrl = err.requestOptions.baseUrl
      ..url = err.requestOptions.uri.toString()
      ..time = DateTime.now()
      ..responseBean = resOpt;
    logManager.onError(errOptions);

    /// TODO
    /// it looks like it's useless code that just duplicates the request
    /// in the console, but we need to make sure it wasn't some kind of crutch
    /// and nothing will break
    // final options = err.requestOptions;
    // final reqOpt = RequestBean()
    //   ..id = options.hashCode
    //   ..url = options.uri.toString()
    //   ..method = options.method
    //   ..contentType = options.contentType?.toString()
    //   ..requestTime = DateTime.now()
    //   ..params = options.queryParameters
    //   ..body = options.data
    //   ..headers = options.headers;
    // logManager.onRequest(reqOpt);

    handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!CRLoggerHelper.instance.doPrintLogs) {
      return handler.next(options);
    }

    final reqOpt = RequestBean()
      ..id = options.hashCode
      ..url = options.uri.toString()
      ..method = options.method
      ..contentType = options.contentType?.toString()
      ..followRedirects = options.followRedirects
      ..requestTime = DateTime.now()
      ..connectTimeout = options.connectTimeout
      ..receiveTimeout = options.receiveTimeout
      ..params = options.queryParameters
      ..body = options.data
      ..headers = options.headers;
    logManager.onRequest(reqOpt);
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (!CRLoggerHelper.instance.doPrintLogs) {
      return handler.next(response);
    }

    final resOpt = ResponseBean()
      ..id = response.requestOptions.hashCode
      ..responseTime = DateTime.now()
      ..statusCode = response.statusCode ?? 0
      ..url = response.requestOptions.uri.toString()
      ..method = response.requestOptions.method
      ..statusMessage = response.statusMessage
      ..data = response.data
      ..headers = response.headers.map;
    logManager.onResponse(resOpt);
    handler.next(response);
  }
}

bool _isNetworkError(SocketException error) {
  final errorCode = error.osError?.errorCode ?? -1;

  return errorCode == 7 || errorCode == 8;
}
