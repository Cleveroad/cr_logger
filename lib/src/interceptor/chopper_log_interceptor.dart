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
      ..id = getRequestHashCode(await request.toBaseRequest())
      ..url = request.url
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
        error,
        stackTrace,
      );
    }

    final resOpt = ResponseBean()
      ..id = getRequestHashCode(response.base.request!)
      ..responseTime = DateTime.now()
      ..statusCode = response.statusCode
      ..data = data.isNotEmpty ? data : response.body
      ..headers = response.headers;
    logManager.onResponse(resOpt);

    return response;
  }

  /// Creates hashcode based on request
  int getRequestHashCode(http.BaseRequest baseRequest) {
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
