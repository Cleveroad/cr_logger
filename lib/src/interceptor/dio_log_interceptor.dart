import 'dart:io';

import 'package:cr_logger/cr_logger.dart';
import 'package:dio/dio.dart';

typedef ParserError = Map<String, dynamic> Function(Object? data);

/// log Format request time
final class DioLogInterceptor implements Interceptor {
  DioLogInterceptor({this.parserError});

  final logManager = HttpLogManager.instance;
  final ParserError? parserError;

  @override
  void onError(DioException err,
      ErrorInterceptorHandler handler,) {
    dynamic json;
    try {
      final errorParser = parserError;
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
      } else if (errorParser != null) {
        json = errorParser(err.error);
      } else {
        throw Exception(err);
      }
    } catch (e, _) {
      json = err.error;
    }
    final resOpt = HttpResponseBean(
      id: err.requestOptions.hashCode,
      responseTime: DateTime.now(),
      statusCode: err.response?.statusCode ?? 0,
      url: Uri(path: err.response?.requestOptions.uri.toString()),
      method: err.response?.requestOptions.method,
      statusMessage: err.response?.statusMessage,
      data: err.response?.data,
      headers: err.response?.headers.map,
    );

    final errOptions = HttpErrorBean(
      id: err.requestOptions.hashCode,
      errorMessage: err.message,
      errorData: json,
      statusCode: err.response?.statusCode,
      statusMessage: err.response?.statusMessage,
      url: Uri(path: err.requestOptions.uri.toString()),
      errorTime: DateTime.now(),
      response: resOpt,

      /// TODO GraphQL: refactor: I dont know, maybe base url is very importent property,
      /// but now i deleted this field from HttpErrorBean
      // ..baseUrl = err.requestOptions.baseUrl
    );

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
    final reqOpt = HttpRequestBean(
      id: options.hashCode,
      url: Uri(path: options.uri.toString()),
      method: options.method,
      contentType: options.contentType.toString(),
      headers: {...options.headers, 'followRedirects': options.followRedirects},
      requestTime: DateTime.now(),
      connectTimeout: options.connectTimeout?.inMilliseconds,
      receiveTimeout: options.receiveTimeout?.inMilliseconds,
      params: options.queryParameters,
      body: options.data,
    );
    logManager.onRequest(reqOpt);
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final resOpt = HttpResponseBean(
      id: response.requestOptions.hashCode,
      responseTime: DateTime.now(),
      statusCode: response.statusCode ?? 0,
      url: Uri(path: response.requestOptions.uri.toString()),
      method: response.requestOptions.method,
      statusMessage: response.statusMessage,
      data: response.data,
      headers: response.headers.map,
    );
    logManager.onResponse(resOpt);
    handler.next(response);
  }
}

bool _isNetworkError(SocketException error) {
  final errorCode = error.osError?.errorCode ?? -1;

  return errorCode == 7 || errorCode == 8;
}
