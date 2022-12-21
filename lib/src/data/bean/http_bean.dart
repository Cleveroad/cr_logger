import 'package:cr_logger/src/data/bean/error_bean.dart' show ErrorBean;
import 'package:cr_logger/src/data/bean/request_bean.dart' show RequestBean;
import 'package:cr_logger/src/data/bean/response_bean.dart' show ResponseBean;
import 'package:cr_logger/src/models/request_status.dart';

class HttpBean {
  HttpBean({
    this.key,
    this.request,
    this.response,
    this.error,
  });

  factory HttpBean.fromJson(Map<String, dynamic> json) {
    return HttpBean(
      key: int.tryParse(json['key']),
      request: json['request'] != null
          ? RequestBean.fromJson(json['request'])
          : null,
      response: json['response'] != null
          ? ResponseBean.fromJson(json['response'])
          : null,
      error: json['error'] != null ? ErrorBean.fromJson(json['error']) : null,
    );
  }

  int? key;
  RequestBean? request;
  ResponseBean? response;

  ErrorBean? error;

  Map<String, dynamic> toJson() => {
        'key': key?.toString(),
        'request': request?.toJson(),
        'response': response?.toJson(),
        'errors': error?.toJson(),
      };
}

extension HttpBeanExtension on HttpBean {
  RequestStatus get status {
    if (error != null) {
      return isInternetError ? RequestStatus.noInternet : RequestStatus.error;
    } else {
      //ignore: prefer-conditional-expressions
      if (response != null) {
        return response?.statusCode == null
            ? RequestStatus.error
            : RequestStatus.success;
      } else {
        return RequestStatus.sending;
      }
    }
  }

  bool get isInternetError {
    if (error?.statusCode != null) {
      return false;
    }

    final errorMessage = error?.errorMessage;
    if (errorMessage != null && errorMessage.contains('Connecting timed out')) {
      return true;
    }

    final errorData = error?.errorData;
    if (errorData is Map<String, dynamic>) {
      final errorCode = errorData['OS Error code'];
      if (errorCode == 7 ||
          errorCode == 8 ||
          errorCode == 101 ||
          errorCode == 103 ||
          errorData['No internet'] == true) {
        return true;
      }
    }

    return false;
  }
}
