import 'package:cr_logger/src/data/bean/base/base_bean.dart';
import 'package:cr_logger/src/data/bean/base/base_response_bean.dart';

abstract class BaseErrorBean extends BaseBean {
  BaseErrorBean({
    required super.id,
    required super.url,
    required this.errorTime,
    super.duration,
    super.headers,
    this.response,
    this.errorMessage,
    this.statusMessage,
    this.statusCode,
  });

  final BaseResponseBean? response;
  final DateTime? errorTime;
  final String? errorMessage;
  final String? statusMessage;
  final int? statusCode;

  @override
  Map<String, dynamic> toJson() =>
      {
        'type': type,
        'id': id,
        'url': url.toString(),
        'response': response?.toJson(),
        'errorTime': errorTime?.toIso8601String(),
        'duration': duration,
        'headers': headers,
        'errorMessage': errorMessage,
        'statusMessage': statusMessage,
        'statusCode': statusCode,
      };
}
