import 'package:cr_logger/cr_logger.dart';
import 'package:http/http.dart' as http;

class CRHttpAdapter {
  HttpLogManager logManager = HttpLogManager.instance;

  /// Handles http response. It creates both request and response from http call
  void onResponse(http.Response response, Object? body) {
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

    final reqOpt = RequestBean()
      ..id = request.hashCode
      ..url = request.url.toString()
      ..method = request.method
      ..contentType = contentType
      ..requestTime = DateTime.now()
      ..body = body
      ..headers = requestHeaders;
    logManager.onRequest(reqOpt);

    final responseHeaders = <String, dynamic>{};

    response.headers.forEach((header, value) {
      responseHeaders[header] = value;
    });

    final resOpt = ResponseBean()
      ..id = request.hashCode
      ..responseTime = DateTime.now()
      ..statusCode = response.statusCode
      ..data = body
      ..headers = responseHeaders;
    logManager.onResponse(resOpt);
  }
}
