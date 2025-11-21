import 'dart:io';

import 'package:cr_logger/cr_logger.dart';

final class CRHttpClientAdapter {
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

    final reqOpt = HttpRequestBean(
      id: request.hashCode,
      url: Uri(path: request.uri.toString()),
      method: request.method,
      contentType: contentType,
      requestTime: DateTime.now(),
      body: body,
      headers: headers,
    );
    logManager.onRequest(reqOpt);
  }

  /// Handles httpClientRequest and adds response to http alice call
  void onResponse(HttpClientResponse response,
      HttpClientRequest request,
      Object? body,) {
    final headers = <String, dynamic>{};

    response.headers.forEach((header, value) {
      headers[header] = value;
    });

    final statusCode = response.statusCode;
    final isError = statusCode < 200 || statusCode >= 300;

    final resOpt = HttpResponseBean(
      id: request.hashCode,
      responseTime: DateTime.now(),
      url: Uri(path: request.uri.toString()),
      method: request.method,
      statusCode: response.statusCode,
      statusMessage: response.reasonPhrase,

      /// In error case, do not put data in ResponseBean.
      data: isError ? null : body,
      headers: headers,
    );
    logManager.onResponse(resOpt);

    /// On error
    if (isError) {
      final errorBean = HttpErrorBean(
        id: request.hashCode,
        url: Uri(path: request.uri.toString()),
        errorTime: DateTime.now(),
        statusCode: response.statusCode,
        statusMessage: response.reasonPhrase,
      );
      logManager.onError(errorBean);
    }
  }
}
