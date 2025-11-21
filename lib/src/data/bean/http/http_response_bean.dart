import 'package:cr_logger/src/data/bean/base/base_response_bean.dart';
import 'package:cr_logger/src/data/bean/visitor/bean_visitor.dart';

class HttpResponseBean extends BaseResponseBean {
  HttpResponseBean({
    required super.id,
    required super.statusCode,
    required super.url,
    required super.responseTime,
    super.statusMessage,
    super.headers,
    super.duration,
    this.data,
    this.method,
  });

  factory HttpResponseBean.fromJson(Map<String, dynamic> json) =>
      HttpResponseBean(
        id: json['id'] as int,
        statusCode: json['statusCode'] as int,
        statusMessage: json['statusMessage'] as String,
        url: Uri.parse(json['url'] as String),
        responseTime: DateTime.parse(json['responseTime'] as String),
        duration: json['duration'],
        headers: json['headers'] != null
            ? Map<String, dynamic>.from(json['headers'] as Map)
            : null,
        data: json['data'],
        method: json['method'] as String?,
      );

  final dynamic data;
  final String? method;

  @override
  void apply(BeanVisitor visitor) => visitor.printHttpResponse(this);

  @override
  Map<String, dynamic> toJson() =>
      {
        ...super.toJson(),
        'method': method,
        'data': data.toString(),
      };
}
