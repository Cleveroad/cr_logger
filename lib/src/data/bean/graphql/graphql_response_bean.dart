import 'package:cr_logger/src/data/bean/base/base_response_bean.dart';
import 'package:cr_logger/src/data/bean/visitor/bean_visitor.dart';

class GraphQLResponseBean extends BaseResponseBean {
  GraphQLResponseBean({
    required super.id,
    required super.statusCode,
    required super.url,
    required super.responseTime,
    super.statusMessage,
    super.headers,
    super.duration,
    this.data,
    this.operationName,
  });

  factory GraphQLResponseBean.fromJson(Map<String, dynamic> json) =>
      GraphQLResponseBean(
        id: json['id'] as int,
        statusCode: json['statusCode'] as int,
        statusMessage: json['statusMessage'] as String,
        url: Uri.parse(json['url'] as String),
        responseTime: DateTime.parse(json['responseTime'] as String),
        duration: json['duration'],
        headers: json['headers'] != null
            ? Map<String, String>.from(json['headers'] as Map)
            : null,
        data: json['data'],
        operationName: json['operationName'] as String?,
      );

  final dynamic data;
  final String? operationName;

  @override
  void apply(BeanVisitor visitor) => visitor.printGraphQLResponse(this);

  @override
  Map<String, dynamic> toJson() =>
      {
        ...super.toJson(),
        'data': data.toString(),
      };
}
