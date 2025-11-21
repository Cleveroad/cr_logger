import 'package:cr_logger/src/data/bean/base/base_request_bean.dart';
import 'package:cr_logger/src/data/bean/visitor/bean_visitor.dart';
import 'package:cr_logger/src/extensions/extensions.dart';
import 'package:dio/dio.dart';

class HttpRequestBean extends BaseRequestBean {
  HttpRequestBean({
    required super.id,
    required super.url,
    required super.requestTime,
    required this.method,
    super.duration,
    super.headers,
    super.connectTimeout,
    super.receiveTimeout,
    super.contentType,
    this.params,
    this.body,
  });

  factory HttpRequestBean.fromJson(Map<String, dynamic> json) =>
      HttpRequestBean(
        id: json['id'] as int,
        url: Uri.parse(json['url'] as String),
        requestTime: DateTime.parse(json['requestTime'] as String),
        method: json['method'] as String,
        duration: json['duration'],
        headers: json['headers'] != null
            ? Map<String, dynamic>.from(json['headers'] as Map)
            : null,
        connectTimeout: json['connectTimeout'] as int?,
        receiveTimeout: json['receiveTimeout'] as int?,
        contentType: json['contentType'] as String?,
        params: json['params'] as Map<String, dynamic>?,
        body: json['body'],
      );

  final String method;
  final Map<String, dynamic>? params;
  dynamic body;

  @override
  void apply(BeanVisitor visitor) => visitor.printHttpRequest(this);

  @override
  Map<String, dynamic> toJson() =>
      {
        ...super.toJson(),
        'method': method,
        'params': params,
        'body': body.toString(),
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
          .map((i) =>
      {
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
