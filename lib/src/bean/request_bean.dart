import 'package:cr_logger/src/extensions/extensions.dart';
import 'package:dio/dio.dart';

class RequestBean {
  RequestBean({
    this.id,
    this.connectTimeout,
    this.receiveTimeout,
    this.url,
    this.method,
    this.contentType,
    this.followRedirects,
    this.requestTime,
    this.headers,
    this.params,
    this.body,
  });

  factory RequestBean.fromJson(Map<String, dynamic> json) {
    dynamic formData;
    final formDataBean = json['FormData'];
    if (formDataBean is List<MapEntry<String, String>>) {
      formData = FormData();
      formData.fields.addAll(formDataBean);
    } else {
      formData = json['FormData'];
    }

    return RequestBean(
      id: json['id'],
      connectTimeout: json['connectTimeout'],
      receiveTimeout: json['receiveTimeout'],
      url: json['url'],
      method: json['method'],
      contentType: json['contentType'],
      followRedirects: json['followRedirects'],
      requestTime: DateTime.tryParse(json['requestTime'] ?? ''),
      headers: json['headers'],
      params: json['params'],
      body: formData ?? json['body'],
    );
  }

  int? id;
  int? connectTimeout;
  int? receiveTimeout;
  String? url;
  String? method;
  String? contentType;
  bool? followRedirects;
  DateTime? requestTime;
  Map<String, dynamic>? headers;
  Map<String, dynamic>? params;
  dynamic body;

  Map<String, dynamic> toJson() => {
        'id': id,
        'connectTimeout': connectTimeout,
        'receiveTimeout': receiveTimeout,
        'url': url,
        'method': method,
        'contentType': contentType,
        'followRedirects': followRedirects,
        'requestTime': requestTime?.toString(),
        'headers': headers,
        'params': params,
        'body': body is FormData ? getFormData() : body,
      };

  Map<String, List<Map<String, String>>> getFormData() {
    final castedFormData = cast<FormData>(body);

    return castedFormData == null
        ? {}
        : {
            'Fields': castedFormData.fields
                .map((i) => {i.key.toString(): i.value.toString()})
                .toList(),
            'Files': castedFormData.files
                .map((i) => {
                      'fileName': i.value.filename ?? '',
                      'fileContentType': i.value.contentType.toString(),
                      'fileHeaders': i.value.headers?.toString() ?? '',
                    })
                .toList(),
          };
  }

  /// Replase body of request if it is FormData with map.
  /// When Files objects are passed to Isolates it may cause crashes running
  /// those functions. Filse should not be passed to Isolates.
  void adaptForIsolatePrinting() {
    if (body is FormData) {
      body = {'FormData': getFormData()};
    }
  }
}
