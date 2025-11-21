import 'package:cr_logger/src/data/bean/base/base_bean.dart';

abstract class BaseRequestBean extends BaseBean {
  BaseRequestBean({
    required super.id,
    required super.url,
    required this.requestTime,
    super.duration,
    super.headers,
    this.connectTimeout,
    this.receiveTimeout,
    this.contentType,
  });

  final int? connectTimeout;
  final int? receiveTimeout;
  final String? contentType;
  final DateTime requestTime;

  @override
  Map<String, dynamic> toJson() =>
      {
        'type': type,
        'id': id,
        'url': url.toString(),
        'requestTime': requestTime.toIso8601String(),
        'duration': duration,
        'headers': headers,
        'connectTimeout': connectTimeout,
        'receiveTimeout': receiveTimeout,
        'contentType': contentType,
      };
}
