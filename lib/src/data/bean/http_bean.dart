import 'package:cr_logger/src/data/bean/http/http_error_bean.dart';
import 'package:cr_logger/src/data/bean/http/http_request_bean.dart';
import 'package:cr_logger/src/data/bean/http/http_response_bean.dart';
import 'package:cr_logger/src/models/request_status.dart';

final class HttpBean {
  HttpBean({
    this.key,
    this.request,
    this.response,
    this.error,
  });

  int? key;
  HttpRequestBean? request;
  HttpResponseBean? response;
  HttpErrorBean? error;
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
