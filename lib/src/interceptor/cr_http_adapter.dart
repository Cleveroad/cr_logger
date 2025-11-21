import 'package:cr_logger/cr_logger.dart';
import 'package:http/http.dart' as http;

final class CRHttpAdapter {
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

    final requestBean = HttpRequestBean(
      id: request.hashCode,
      url: Uri(path: request.url.toString()),
      method: request.method,
      contentType: contentType,
      requestTime: DateTime.now(),
      body: body,
      headers: requestHeaders,
    );
    logManager.onRequest(requestBean);

    final responseHeaders = <String, dynamic>{};

    response.headers.forEach((header, value) {
      responseHeaders[header] = value;
    });

    final statusCode = response.statusCode;
    final isError = statusCode < 200 || statusCode >= 300;

    final responseBean = HttpResponseBean(
      id: request.hashCode,
      responseTime: DateTime.now(),
      url: Uri(path: request.url.toString()),
      method: request.method,
      statusCode: response.statusCode,
      statusMessage: response.reasonPhrase,

      /// In error case, do not put data in ResponseBean.
      data: isError ? null : body,
      headers: responseHeaders,
    );

    logManager.onResponse(responseBean);

    /// On error
    if (isError) {
      final errorBean = HttpErrorBean(
        id: request.hashCode,
        url: Uri(path: request.url.toString()),
        errorTime: DateTime.now(),
        statusCode: response.statusCode,
        statusMessage: response.reasonPhrase,
      );
      logManager.onError(errorBean);
    }
  }
}
