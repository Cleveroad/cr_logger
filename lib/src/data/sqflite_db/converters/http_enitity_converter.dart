import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/data/sqflite_db/entities/http_entity.dart';
import 'package:cr_logger/src/utils/parsers/isolate_parser.dart';

class HttpEntityConverter {
  final _parser = IsolateParser();

  Future<HttpBean> inToOut(HttpEntity inObject) async {
    final request = await _decode(inObject.request);
    final response = await _decode(inObject.response);
    final error = await _decode(inObject.error);

    return HttpBean(
      key: inObject.key,
      request: request != null ? RequestBean.fromJson(request) : null,
      response: response != null ? ResponseBean.fromJson(response) : null,
      error: error != null ? ErrorBean.fromJson(error) : null,
    );
  }

  Future<HttpEntity> outToIn(HttpBean outObject) async {
    final request = outObject.request;
    final response = outObject.response;
    final error = outObject.error;

    return HttpEntity(
      key: outObject.key,
      request: await _encode(request, request?.toJson()),
      response: await _encode(response, response?.toJson()),
      error: await _encode(error, error?.toJson()),
    );
  }

  dynamic _decode(String? json) async =>
      json != null ? await _parser.decode(json) : null;

  Future<String?> _encode(dynamic object, Map<String, dynamic>? json) async =>
      object != null ? await _parser.encode(json) : null;
}
