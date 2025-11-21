import 'package:cr_logger/src/data/bean/base/base_bean.dart';
import 'package:cr_logger/src/data/bean/base/base_error_bean.dart';
import 'package:cr_logger/src/data/bean/graphql/graphql_response_bean.dart';
import 'package:cr_logger/src/data/bean/visitor/bean_visitor.dart';
import 'package:gql_exec/gql_exec.dart';

final class GraphqlErrorBean extends BaseErrorBean {
  GraphqlErrorBean({
    required super.id,
    required super.url,
    required super.errorTime,
    required this.errorData,
    super.response,
    super.duration,
    super.headers,
    super.errorMessage,
    super.statusMessage,
    super.statusCode,
    this.gqlErrors = const [],
    this.operationName,
  });

  factory GraphqlErrorBean.fromJson(Map<String, dynamic> json) {
    return GraphqlErrorBean(
      id: json['id'] as int,
      url: Uri.parse(json['url'] as String),
      response: BaseBean.fromJson(json['response'] as Map<String, dynamic>)
      as GraphQLResponseBean,
      errorTime: DateTime.parse(json['errorTime'] as String),
      errorData: json['errorData'],
      duration: json['duration'],
      headers: json['headers'] != null
          ? Map<String, String>.from(json['headers'] as Map)
          : null,
      errorMessage: json['errorMessage'] as String?,
      statusMessage: json['statusMessage'] as String?,
      statusCode: json['statusCode'] as int?,
    );
  }

  final List<GraphQLError> gqlErrors;
  final dynamic errorData;
  final String? operationName;

  @override
  void apply(BeanVisitor visitor) => visitor.printGraphQLError(this);

  @override
  Map<String, dynamic> toJson() =>
      {
        ...super.toJson(),
        'errorData': errorData,
      };
}
