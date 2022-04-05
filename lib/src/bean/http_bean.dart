import 'package:cr_logger/src/bean/error_bean.dart' show ErrorBean;
import 'package:cr_logger/src/bean/request_bean.dart' show RequestBean;
import 'package:cr_logger/src/bean/response_bean.dart' show ResponseBean;

class HttpBean {
  HttpBean({
    this.request,
    this.response,
    this.error,
  });

  factory HttpBean.fromJson(Map<String, dynamic> json) {
    return HttpBean(
      request: json['request'] != null
          ? RequestBean.fromJson(json['request'])
          : null,
      response: json['response'] != null
          ? ResponseBean.fromJson(json['response'])
          : null,
      error: json['error'] != null ? ErrorBean.fromJson(json['error']) : null,
    );
  }

  RequestBean? request;
  ResponseBean? response;

  ErrorBean? error;

  Map<String, dynamic> toJson() => {
        'request': request?.toJson(),
        'response': response?.toJson(),
        'errors': error?.toJson(),
      };
}
