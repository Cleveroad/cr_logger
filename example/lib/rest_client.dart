import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:cr_logger/cr_logger.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

class RestClient {
  RestClient._() {
    dio = Dio()
      ..options.receiveTimeout = _serverTimeout
      ..options.connectTimeout = _serverTimeout
      ..options.sendTimeout = _serverTimeout;

    dio.interceptors.add(
      CRLoggerInitializer.instance.getDioInterceptor(),
    );
    chopper = ChopperClient(interceptors: [
      CRLoggerInitializer.instance.getChopperInterceptor(),
    ]);
  }

  static const _serverTimeout = 15000;
  static final RestClient instance = RestClient._();

  late Dio dio;
  late ChopperClient chopper;

  /// Init proxy for Dio client.
  void initDioProxyForCharles(String proxy) {
    final split = proxy.split(':');
    final ip = split.first;
    final port = split[1];

    final proxyStr = 'PROXY $ip:$port; '
        'PROXY localhost:$port; DIRECT';
    final adapter = dio.httpClientAdapter;
    if (adapter is DefaultHttpClientAdapter) {
      adapter.onHttpClientCreate = (HttpClient client) {
        client
          ..findProxy = (uri) {
            return proxyStr;
          }
          ..badCertificateCallback = (
            X509Certificate cert,
            String host,
            int port,
          ) =>
              true;

        return null;
      };
    }
  }
}
