import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/cr_logger_helper.dart';
import 'package:http/http.dart' as http;

class CRHttpAdapter {
  HttpLogManager logManager = HttpLogManager.instance;

  /// Handles http response. It creates both request and response from http call
  void onResponse(http.Response response, Object? body) {
    if (!CRLoggerHelper.instance.doPrintLogs) {
      return;
    }

    if (response.request == null) {
      return;
    }
    final request = response.request!;

    final requestHeaders = <String, dynamic>{};

    request.headers.forEach((header, value) {
      requestHeaders[header] = value;
    });

    String? contentType = 'unknown';
    if (requestHeaders.containsKey('Content-Type')) {
      contentType = requestHeaders['Content-Type'] as String?;
    }

    final requestBean = RequestBean()
      ..id = request.hashCode
      ..url = request.url.toString()
      ..method = request.method
      ..contentType = contentType
      ..requestTime = DateTime.now()
      ..body = body
      ..headers = requestHeaders;
    logManager.onRequest(requestBean);

    final responseHeaders = <String, dynamic>{};

    response.headers.forEach((header, value) {
      responseHeaders[header] = value;
    });

    final statusCode = response.statusCode;
    final isError = statusCode < 200 || statusCode >= 300;

    final responseBean = ResponseBean()
      ..id = request.hashCode
      ..responseTime = DateTime.now()
      ..url = request.url.toString()
      ..method = request.method
      ..statusCode = response.statusCode
      ..statusMessage = response.reasonPhrase

      /// In error case, do not put data in ResponseBean.
      ..data = isError ? null : body
      ..headers = responseHeaders;
    logManager.onResponse(responseBean);

    /// On error
    if (isError) {
      final errorBean = ErrorBean()
        ..id = request.hashCode
        ..url = request.url.toString()
        ..time = DateTime.now()
        ..statusCode = response.statusCode
        ..statusMessage = response.reasonPhrase;
      logManager.onError(errorBean);
    }
  }
}
