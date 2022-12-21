import 'package:cr_logger/src/utils/map_ext.dart';

class HttpEntity {
  HttpEntity({
    this.key,
    this.request,
    this.response,
    this.error,
  });

  factory HttpEntity.fromJson(Map<String, dynamic> json) {
    return HttpEntity(
      key: json['key'],
      request: json['request'],
      response: json['response'],
      error: json['error'],
    );
  }

  int? key;
  String? request;
  String? response;
  String? error;

  Map<String, dynamic> toJson() {
    final json = {
      'key': key?.toString(),
      'request': request,
      'response': response,
      'error': error,
    };

    // ignore: cascade_invocations
    json.clearAllNull();

    return json;
  }
}
