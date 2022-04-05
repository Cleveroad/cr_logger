class ProxyModel {
  ProxyModel(this.ip, this.port);

  final String ip;
  final String port;

  String get ipAndPortString => '$ip:$port';

  static ProxyModel? fromString(String iPAndPort) {
    final split = iPAndPort.split(':');
    if (split.length == 2) {
      // ignore: prefer-first
      return ProxyModel(split[0], split[1]);
    }

    return null;
  }
}
