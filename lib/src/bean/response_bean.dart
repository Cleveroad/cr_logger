class ResponseBean {
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
      responseTime: DateTime.tryParse(json['responseTime'] ?? ''),
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

    return {
      'id': id,
      'statusCode': statusCode,
      'url': url,
      'method': method,
      'statusMessage': statusMessage,
      'responseTime': responseTime?.toIso8601String(),
      'duration': duration,
      'headers': headers,
      'data': data,
    };
  }
}
