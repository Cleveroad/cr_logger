///Just a stub. Used to replace import if not web
class Worker {
  Worker(this.stubPath);

  final String stubPath;

  Stream<MessageEvent> get onMessage {
    throw UnimplementedError('Unsupported');
  }

  // ignore: no-empty-block, avoid-unused-parameters, avoid_annotating_with_dynamic
  void postMessage([dynamic data]) {}

// ignore: no-empty-block,
  void terminate() {}
}

class MessageEvent {
  dynamic get data {
    throw UnimplementedError('Unsupported');
  }
}
