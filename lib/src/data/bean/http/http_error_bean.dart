import 'package:cr_logger/src/data/bean/base/base_bean.dart';
import 'package:cr_logger/src/data/bean/base/base_error_bean.dart';
import 'package:cr_logger/src/data/bean/http/http_response_bean.dart';
import 'package:cr_logger/src/data/bean/visitor/bean_visitor.dart';

final class HttpErrorBean extends BaseErrorBean {
  HttpErrorBean({
    required super.id,
    required super.url,
    required super.errorTime,
    super.response,
    super.duration,
    super.headers,
    super.errorMessage,
    super.statusMessage,
    super.statusCode,
    this.errorData,
  });

  factory HttpErrorBean.fromJson(Map<String, dynamic> json) => HttpErrorBean(
        id: json['id'] as int,
        url: Uri.parse(json['url'] as String),
        response: json['response'] != null
            ? BaseBean.fromJson(json['response'] as Map<String, dynamic>)
                as HttpResponseBean
            : null,
        errorTime: DateTime.tryParse(json['errorTime'] as String? ?? ''),
        errorData: json['errorData'],
        duration: json['duration'],
        headers: json['headers'] != null
            ? Map<String, dynamic>.from(json['headers'] as Map)
            : null,
        errorMessage: json['errorMessage'] as String?,
        statusMessage: json['statusMessage'] as String?,
        statusCode: json['statusCode'] as int?,
      );

  final dynamic errorData;

  @override
  void apply(BeanVisitor visitor) => visitor.printHttpError(this);

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'errorData': errorData.toString(),
      };
}
