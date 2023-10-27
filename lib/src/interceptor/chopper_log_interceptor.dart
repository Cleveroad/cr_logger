import 'dart:async';
import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:cr_logger/cr_logger.dart';
import 'package:http/http.dart' as http;

class ChopperLogInterceptor extends ResponseInterceptor
    with RequestInterceptor {
  final logManager = HttpLogManager.instance;

  @override
  FutureOr<Request> onRequest(Request request) async {
    final reqOpt = RequestBean()
      ..id = _getRequestHashCode(await request.toBaseRequest())
      ..url = request.url.toString()
      ..method = request.method
      ..contentType = request.headers['Content-Type'].toString()
      ..requestTime = DateTime.now()
      ..params = request.parameters
      ..body = request.body
      ..headers = request.headers;
    logManager.onRequest(reqOpt);

    return request;
  }

  @override
  FutureOr<Response> onResponse(Response<dynamic> response) {
    var data = <String, dynamic>{};
    try {
      data = json.decode(response.body as String);
    } catch (error, stackTrace) {
      log.e(
        'Chopper interceptor error',
        error: error,
        stackTrace: stackTrace,
      );
    }

    final requestId = _getRequestHashCode(response.base.request!);
    final statusCode = response.statusCode;
    final isError = statusCode < 200 || statusCode >= 300;

    /// In error case, do not put data in ResponseBean.
    final dynamic responseData;
    //ignore: prefer-conditional-expressions
    if (isError) {
      responseData = null;
    } else {
      responseData = data.isNotEmpty ? data : response.body;
    }

    final responseBean = ResponseBean()
      ..id = requestId
      ..responseTime = DateTime.now()
      ..statusCode = response.statusCode
      ..url = response.base.request?.url.toString()
      ..method = response.base.request?.method
      ..statusMessage = response.base.reasonPhrase
      ..data = responseData
      ..headers = response.headers;
    logManager.onResponse(responseBean);

    /// On error
    if (isError) {
      final errorBean = ErrorBean()
        ..id = requestId
        ..errorData = response.error
        ..statusCode = statusCode
        ..statusMessage = response.base.reasonPhrase
        ..url = response.base.request?.url.toString()
        ..time = DateTime.now();
      logManager.onError(errorBean);
    }

    return response;
  }

  /// Creates hashcode based on request
  int _getRequestHashCode(http.BaseRequest baseRequest) {
    var hashCodeSum = 0;

    hashCodeSum += baseRequest.url.hashCode;
    hashCodeSum += baseRequest.method.hashCode;
    if (baseRequest.headers.isNotEmpty) {
      baseRequest.headers.forEach((key, value) {
        hashCodeSum += key.hashCode;
        hashCodeSum += value.hashCode;
      });
    }
    if (baseRequest.contentLength != null) {
      hashCodeSum += baseRequest.contentLength.hashCode;
    }

    return hashCodeSum.hashCode;
  }
}
