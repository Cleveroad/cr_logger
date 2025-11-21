import 'dart:async';
import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:cr_logger/cr_logger.dart';
import 'package:http/http.dart' as http;

final class ChopperLogInterceptor implements Interceptor {
  final logManager = HttpLogManager.instance;

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

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
      Chain<BodyType> chain) async {
    final request = chain.request;
    final reqOpt = HttpRequestBean(
      id: _getRequestHashCode(await request.toBaseRequest()),
      url: request.url,
      method: request.method,
      contentType: request.headers['Content-Type'].toString(),
      requestTime: DateTime.now(),
      params: request.parameters,
      body: request.body,
      headers: request.headers,
    );
    logManager.onRequest(reqOpt);

    final response = await chain.proceed(request);

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

    final responseBean = HttpResponseBean(
      id: requestId,
      responseTime: DateTime.now(),
      statusCode: response.statusCode,
      url: Uri(path: response.base.request?.url.toString()),
      method: response.base.request?.method,
      statusMessage: response.base.reasonPhrase,
      data: responseData,
      headers: response.headers,
    );
    await logManager.onResponse(responseBean);

    /// On error
    if (isError) {
      final errorBean = HttpErrorBean(
        id: requestId,
        errorData: response.error,
        statusCode: statusCode,
        statusMessage: response.base.reasonPhrase,
        url: Uri(path: response.base.request?.url.toString()),
        errorTime: DateTime.now(),
      );
      logManager.onError(errorBean);
    }

    return response;
  }
}
