import 'dart:io';

import 'package:cr_logger/cr_logger.dart';

class CRHttpClientAdapter {
  HttpLogManager logManager = HttpLogManager.instance;

  /// Handles httpClientRequest and creates http alice call from it
  void onRequest(HttpClientRequest request, Object? body) {
    final headers = <String, dynamic>{};

    request.headers.forEach((header, value) {
      headers[header] = value;
    });

    String? contentType = 'unknown';
    if (headers.containsKey('Content-Type')) {
      contentType = headers['Content-Type'] as String?;
    }

    final reqOpt = RequestBean()
      ..id = request.hashCode
      ..url = request.uri.toString()
      ..method = request.method
      ..contentType = contentType
      ..requestTime = DateTime.now()
      ..body = body
      ..headers = headers;

    logManager.onRequest(reqOpt);
  }

  /// Handles httpClientRequest and adds response to http alice call
  void onResponse(
    HttpClientResponse response,
    HttpClientRequest request,
    Object? body,
  ) {
    final headers = <String, dynamic>{};

    response.headers.forEach((header, value) {
      headers[header] = value;
    });

    final resOpt = ResponseBean()
      ..id = request.hashCode
      ..responseTime = DateTime.now()
      ..statusCode = response.statusCode
      ..data = body
      ..headers = headers;
    logManager.onResponse(resOpt);
  }
}
