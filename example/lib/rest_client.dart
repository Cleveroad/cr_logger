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

    if (CRLoggerInitializer.instance.isPrintingLogs) {
      dio.interceptors.add(
        CRLoggerInitializer.instance.getDioInterceptor(),
      );
      chopper = ChopperClient(interceptors: [
        CRLoggerInitializer.instance.getChopperInterceptor(),
      ]);
    } else {
      chopper = ChopperClient();
    }
  }

  static final RestClient instance = RestClient._();
  static const _serverTimeout = 15000;

  late Dio dio;
  late ChopperClient chopper;

  /// Enable proxy for Dio client.
  void enableDioProxyForCharles(ProxyModel proxyModel) {
    final proxyStr = 'PROXY ${proxyModel.ip}:${proxyModel.port}; '
        'PROXY localhost:${proxyModel.port}; DIRECT';
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
