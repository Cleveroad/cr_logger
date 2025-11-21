import 'package:cr_logger/src/data/bean/base/base_bean.dart';

abstract class BaseResponseBean extends BaseBean {
  BaseResponseBean({
    required super.id,
    required super.url,
    required this.statusCode,
    required this.responseTime,
    super.duration,
    super.headers,
    this.statusMessage,
  });

  final int? statusCode;
  final String? statusMessage;
  final DateTime responseTime;

  @override
  Map<String, dynamic> toJson() =>
      {
        'type': type,
        'id': id,
        'url': url.toString(),
        'statusCode': statusCode,
        'statusMessage': statusMessage,
        'responseTime': responseTime.toIso8601String(),
        'duration': duration,
        'headers': headers,
      };
}
