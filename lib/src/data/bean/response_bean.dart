import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/constants.dart';
import 'package:cr_logger/src/utils/hide_values_in_map.dart';

final class ResponseBean {
  ResponseBean({
    this.id,
    this.statusCode,
    this.url,
    this.method,
    this.statusMessage,
    this.responseTime,
    this.duration,
    this.data,
    this.headers,
  });

  factory ResponseBean.fromJson(Map<String, dynamic> json) {
    return ResponseBean(
      id: json['id'],
      statusCode: json['statusCode'],
      url: json['url'],
      method: json['method'],
      statusMessage: json['statusMessage'],
      responseTime: DateTime.tryParse(json['responseTime'] ?? '')?.toLocal(),
      duration: json['duration'],
      data: json['data'],
      headers: json['headers'],
    );
  }

  int? id;
  int? statusCode;
  String? url;
  String? method;
  String? statusMessage;
  DateTime? responseTime;
  int? duration;
  dynamic data;
  Map<String, dynamic>? headers;

  Map<String, Object?> toJson() {
    final headers = <String, String>{};
    this.headers?.forEach((k, list) => headers[k] = list.toString());
    final changedHeaders = headers.map((key, value) {
      return CRLoggerInitializer.instance.hiddenHeaders.contains(key)
          ? MapEntry(key, kHidden)
          : MapEntry(key, value);
    });
    Map? changedData;
    if (data is Map) {
      changedData = hideValuesInMap(data);
    }

    return {
      'id': id,
      'statusCode': statusCode,
      'url': url,
      'method': method,
      'statusMessage': statusMessage,
      'responseTime': responseTime?.toUtc().toString(),
      'duration': duration,
      'headers': changedHeaders,
      'data': changedData,
    };
  }
}
