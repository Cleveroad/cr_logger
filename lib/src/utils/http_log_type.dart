enum HttpLogType {
  request,
  response,
  error,
}

extension HttpLogTypeExt on HttpLogType {
  String asString() {
    switch (this) {
      case HttpLogType.request:
        return 'Request';
      case HttpLogType.response:
        return 'Response';
      case HttpLogType.error:
        return 'Error';
    }
  }
}
