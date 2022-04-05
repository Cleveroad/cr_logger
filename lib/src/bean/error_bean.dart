import 'package:cr_logger/src/bean/response_bean.dart';

class ErrorBean {
  ErrorBean({
    this.id,
    this.errorMessage,
    this.statusMessage,
    this.time,
    this.responseBean,
    this.duration,
    this.statusCode,
    this.baseUrl,
    this.url,
    this.errorData,
  });

  factory ErrorBean.fromJson(Map<String, dynamic> json) {
    return ErrorBean(
      id: json['id'],
      errorMessage: json['errorMessage'],
      url: json['url'],
      time: DateTime.tryParse(json['time'] ?? ''),
      responseBean: ResponseBean.fromJson(json['responseBean']),
      duration: json['duration'],
    );
  }

  int? id;
  dynamic errorData;
  String? errorMessage;
  String? statusMessage;
  String? baseUrl;
  String? url;
  DateTime? time;
  ResponseBean? responseBean;
  int? duration;
  int? statusCode;

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'errorMessage': errorMessage,
        'time': time?.toIso8601String(),
        'responseBean': responseBean?.toJson(),
        'duration': duration,
        'statusCode': statusCode,
        'statusMessage': statusMessage,
      };
}
