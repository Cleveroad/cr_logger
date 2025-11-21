import 'package:cr_logger/src/data/bean/base/base_request_bean.dart';
import 'package:cr_logger/src/data/bean/visitor/bean_visitor.dart';

class GraphQLRequestBean extends BaseRequestBean {
  GraphQLRequestBean({
    required super.id,
    required super.url,
    required super.requestTime,
    super.duration,
    super.headers,
    super.connectTimeout,
    super.receiveTimeout,
    super.contentType,
    this.variables,
    this.operationName,
    this.operationType,
  });

  factory GraphQLRequestBean.fromJson(Map<String, dynamic> json) {
    return GraphQLRequestBean(
      id: json['id'] as int,
      url: Uri.parse(json['url'] as String),
      requestTime: DateTime.parse(json['requestTime'] as String),
      duration: json['duration'],
      headers: json['headers'] != null
          ? Map<String, String>.from(json['headers'] as Map)
          : null,
      connectTimeout: json['connectTimeout'] as int?,
      receiveTimeout: json['receiveTimeout'] as int?,
      contentType: json['contentType'] as String?,
      variables: json['variables'] as Map<String, dynamic>?,
    );
  }

  final String? operationName;
  final String? operationType;
  final Map<String, dynamic>? variables;

  @override
  void apply(BeanVisitor visitor) => visitor.printGraphQLRequest(this);

  @override
  Map<String, dynamic> toJson() =>
      {
        ...super.toJson(),
        'operation': {
          // 'operationName': operation.operationName,
          // 'document': operation.document.toString(),
          // 'operationType': operation.getOperationType()?.name,
        },
        'variables': variables,
      };

// @override
// Map<String, dynamic> get meta => {
//       'Operation Name': operation.operationName ?? '',
//       'Query': operation.document.toString(),
//       if (variables != null) 'Variables': variables,
//     };
}
