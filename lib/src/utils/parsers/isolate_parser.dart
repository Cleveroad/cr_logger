import 'dart:convert';

import 'package:worker_manager/worker_manager.dart';

/// This class is for converting a [String] into a [Map] and conversely.
class IsolateParser {
  ///[data] is a string, but may contain a map, so a decoding attempt is made first. If it fails, [data] is returned as a string.
  dynamic decode(String data) => workerManager.execute<dynamic>(
        () => _decode(data),
      );

  /// [data] can be any type, so there is a check if it is a map, then [json.encode] is called,
  /// otherwise [data] is converted into a string and returned.
  Future<String> encode(dynamic data) => workerManager.execute<String>(
        () => _encode(data),
      );
}

dynamic _decode(String data) {
  try {
    return json.decode(data);
  } catch (_) {
    return Future.value(data);
  }
}

String _encode(dynamic data) =>
    data is Map<String, dynamic> ? json.encode(data) : data.toString();
