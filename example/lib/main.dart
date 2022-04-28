import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger_example/generated/assets.dart';
import 'package:cr_logger_example/rest_client.dart';
import 'package:cr_logger_example/widgets/example_btn.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:logger/logger.dart';
import 'package:share_plus/share_plus.dart';
import 'package:worker_manager/worker_manager.dart';

String? proxyIpAndPortString;

Future<void> main() async {
  // Call this first if main function is async
  WidgetsFlutterBinding.ensureInitialized();

  // Warmup executor, used for convenient usage of Isolates, without manual
  // creation and management of isolates.
  await Executor().warmUp();

  // First! Initialize logger
  await CRLoggerInitializer.instance.init(
    theme: ThemeData.light(),
    levelColors: {
      Level.debug: Colors.grey.shade300,
      Level.warning: Colors.orange,
    },
    hiddenFields: [
      'token',
    ],
    logFileName: 'my_logs',
  );

  // Second! Define the callbacks
  CRLoggerInitializer.instance.onLogout = () async {
    // logout simulation
    await Future.delayed(const Duration(seconds: 1));
  };
  CRLoggerInitializer.instance.onProxyChanged = (ProxyModel proxyModel) {
    proxyIpAndPortString = proxyModel.ipAndPortString;
    RestClient.instance.enableDioProxyForCharles(proxyModel);
  };
  CRLoggerInitializer.instance.onGetProxyFromDB = () {
    return ProxyModel.fromString(proxyIpAndPortString ?? '');
  };
  CRLoggerInitializer.instance.onShareLogsFile = (path) async {
    await Share.shareFiles([path]);
  };

  // Third! Define the variables
  CRLoggerInitializer.instance.buildType = 'release';
  CRLoggerInitializer.instance.endpoints = ['https/cr_logger/example/'];

  final proxy = ProxyModel.fromString(proxyIpAndPortString ?? '');
  if (proxy != null) {
    RestClient.instance.enableDioProxyForCharles(proxy);
  }

  // Provide isolated execution callback for other CrLogger functions
  // (e.g. printing logs)
  CRLoggerInitializer.instance.handleFunctionInIsolate = (fun, data) async {
    return await Executor().execute(
      arg1: data,
      fun1: fun,
    );
  };

  // Provide isolated execution callback for parsing json string in CrLogger.
  CRLoggerInitializer.instance.parseiOSJsonStringInIsolate = (fun, json) async {
    return await Executor().execute(
      arg1: json,
      fun1: fun,
    );
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainPage(),
      builder: (context, child) => CrInspector(child: child!),
      theme: ThemeData(fontFamily: 'Epilogue'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const platform = MethodChannel('com.cleveroad.cr_logger_example/logs');
  final _debouncer = Debouncer(100);
  late DropzoneViewController _dropCtrl;
  bool _dragging = false;

  @override
  void initState() {
    // Third! Initialize debug button
    CRLoggerInitializer.instance.showDebugButton(
      context,
      left: 16,
    );

    /// Type notifiers
    final integerNotifier = ValueNotifier<int>(0);
    final doubleNotifier = ValueNotifier<double>(0);
    final boolNotifier = ValueNotifier<bool>(false);
    final stringNotifier = ValueNotifier<String>('integer: ');

    /// Widget notifiers
    final iconNotifier = ValueNotifier<Icon>(const Icon(Icons.clear));
    final textNotifier = ValueNotifier<Text>(const Text('Widget text'));

    /// Type notifiers changes
    Timer.periodic(const Duration(seconds: 1), (_) => integerNotifier.value++);
    Timer.periodic(const Duration(milliseconds: 1), (_) {
      doubleNotifier
        ..value += 0.1
        ..value = double.parse(doubleNotifier.value.toStringAsFixed(3));
    });
    Timer.periodic(const Duration(seconds: 1),
        (_) => boolNotifier.value = !boolNotifier.value);
    Timer.periodic(const Duration(seconds: 1),
        (_) => stringNotifier.value = 'number: ${integerNotifier.value}');

    /// Widget notifiers changes
    Timer.periodic(
      const Duration(seconds: 1),
      (_) => Icon(boolNotifier.value
          ? Icons.airline_seat_flat
          : Icons.airline_seat_flat_angled),
    );

    Timer.periodic(
      const Duration(seconds: 1),
      (_) => iconNotifier.value = Icon(boolNotifier.value
          ? Icons.airline_seat_flat
          : Icons.airline_seat_flat_angled),
    );

    Timer.periodic(
      const Duration(seconds: 1),
      (_) => textNotifier.value = Text(
        'Widget text',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: boolNotifier.value ? FontWeight.bold : FontWeight.normal,
          fontFamily: 'Epilogue',
        ),
      ),
    );

    CRLoggerInitializer.instance
        .popupItemAddNotifier('Integer', integerNotifier);
    CRLoggerInitializer.instance.popupItemAddNotifier('Double', doubleNotifier);
    CRLoggerInitializer.instance.popupItemAddNotifier('Bool', boolNotifier);
    CRLoggerInitializer.instance.popupItemAddNotifier('String', stringNotifier);
    CRLoggerInitializer.instance.popupItemAddNotifier('Icon', iconNotifier);
    CRLoggerInitializer.instance.popupItemAddNotifier('Text', textNotifier);

    /// Actions
    CRLoggerInitializer.instance
        .popupItemAddAction('Log Hi', () => log.i('Hi'));
    CRLoggerInitializer.instance
        .popupItemAddAction('Log By', () => log.i('By'));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F6),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              'CR Logger example app',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 28),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 592),
                    child: Column(
                      children: [
                        if (kIsWeb) ...[
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: _dragging
                                  ? Colors.white.withOpacity(0.4)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [
                                const Center(
                                  child: Text(
                                    'drop logs here',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),

                                ///TODO Check it later
                                /// For some reason, the Inspector package cannot
                                /// get the color if there is a [DropzoneView]
                                /// on the screen and throws an error
                                /// (probably due to the flatter)
                                /// if the [DropzoneView] is not assigned
                                /// a new key each time.
                                /// Because of this, frequent rebuilds
                                /// of the widget and constant firing
                                /// of callbacks can occur.
                                /// For this reason, a debouncer is now used to avoid this.
                                DropzoneView(
                                  key: UniqueKey(),
                                  operation: DragOperation.move,
                                  onCreated: (ctrl) => _dropCtrl = ctrl,
                                  onDrop: _onDrop,
                                  onHover: () {
                                    _debouncer.dispose();
                                    if (!_dragging) {
                                      setState(() => _dragging = true);
                                    }
                                  },
                                  onLeave: () {
                                    _debouncer.run(() {
                                      setState(() => _dragging = false);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        Row(
                          children: [
                            Expanded(
                              child: ExampleBtn(
                                text: 'Make HTTP request',
                                assetName: Assets.assetsIcHttp,
                                onTap: _makeHttpRequest,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ExampleBtn(
                                text: 'Make JSON log',
                                assetName: Assets.assetsIcJson,
                                onTap: _makeLogJson,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ExampleBtn(
                                text: 'Log debug',
                                assetName: Assets.assetsIcDebug,
                                onTap: _makeLogDebug,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ExampleBtn(
                                text: 'Log debug native',
                                assetName: Assets.assetsIcDebugNative,
                                onTap: kIsWeb ? null : _makeLogDebugNative,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ExampleBtn(
                                text: 'Log warning',
                                assetName: Assets.assetsIcWarning,
                                onTap: _makeLogWarning,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ExampleBtn(
                                text: 'Log warning native',
                                assetName: _getWarningNativeAsset(),
                                onTap: kIsWeb ? null : _makeLogWarningNative,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ExampleBtn(
                                text: 'Log error',
                                assetName: Assets.assetsIcError,
                                onTap: _makeLogError,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ExampleBtn(
                                text: 'Log error native',
                                assetName: _getErrorNativeAsset(),
                                onTap: kIsWeb ? null : _makeLogErrorNative,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Expanded(child: SizedBox()),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ExampleBtn(
                                text: 'Make native JSON log',
                                assetName: _getErrorNativeAsset(),
                                onTap: kIsWeb ? null : _makeNativeLogJson,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blueGrey,
                          ),
                          onPressed: () => _toggleDebugButton(context),
                          child: const Text(
                            'Toggle debug button',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleDebugButton(BuildContext context) {
    if (CRLoggerInitializer.instance.isDebugButtonDisplayed) {
      CRLoggerInitializer.instance.dismissDebugButton();
    } else {
      CRLoggerInitializer.instance.showDebugButton(
        context,
        left: 16,
      );
    }
  }

  Future<void> _makeHttpRequest() async {
    final queryParameters = <String, dynamic>{};

    for (var i = 0; i < 2; ++i) {
      queryParameters.addAll(<String, dynamic>{
        'null_$i': null,
        'bool_$i': true,
        'int_$i': 256,
        'double_$i': 1.23,
        'string_$i': 'text',
        'map_$i': {
          'int': 256,
          'double': 1.23,
          'string': 'text',
        },
        'array_$i': [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
      });
    }
    await RestClient.instance.dio.get(
      'https://httpbin.org/json',
      queryParameters: queryParameters,
    );
  }

  String _getWarningNativeAsset() {
    if (kIsWeb) {
      return Assets.assetsIcWarning;
    } else if (Platform.isIOS) {
      return Assets.assetsIcWarningIos;
    } else {
      return Assets.assetsIcWarningAndroid;
    }
  }

  String _getErrorNativeAsset() {
    if (kIsWeb) {
      return Assets.assetsIcError;
    } else if (Platform.isIOS) {
      return Assets.assetsIcErrorIos;
    } else {
      return Assets.assetsIcErrorAndroid;
    }
  }

  void _makeLogDebug() {
    log
      ..d('Debug message at ${DateTime.now().toIso8601String()}')
      ..v('Verbose message at ${DateTime.now().toIso8601String()}');
  }

  void _makeLogJson() {
    final data = {
      'a': 1,
      'b': 2,
      'c': 3,
      'str1': 'string1',
      'str2': 'string2',
      'tempData': {
        'a': 1,
        'b': 2,
        'c': 3,
        'str1': 'string1',
        'str2': 'string2',
      }
    };

    log
      ..d(data)
      ..i(data)
      ..e(data);
  }

  void _makeLogWarning() {
    log
      ..w('Warning message at ${DateTime.now().toIso8601String()}')
      ..i('Info message at ${DateTime.now().toIso8601String()}');
  }

  void _makeLogError() {
    log
      ..e('Error message at ${DateTime.now().toIso8601String()}',
          const HttpException('message'))
      ..wtf('Wtf message at ${DateTime.now().toIso8601String()}');
  }

  void _makeLogDebugNative() {
    platform.invokeMethod('debug');
  }

  void _makeLogWarningNative() {
    platform.invokeMethod('info');
  }

  void _makeLogErrorNative() {
    platform.invokeMethod('error');
  }

  void _makeNativeLogJson() {
    platform.invokeMethod('logJson');
  }

  Future<void> _onDrop(dynamic value) async {
    final bytes = await _dropCtrl.getFileData(value);
    try {
      final json = await compute(jsonDecode, utf8.decode(bytes));
      await CRLoggerInitializer.instance.createLogsFromJson(json);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logs successfully imported'),
        ),
      );
    } catch (ex) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unsupported file'),
        ),
      );
    }
    setState(() {
      _dragging = false;
    });
  }
}

class Debouncer {
  Debouncer(this.milliseconds);

  final int milliseconds;
  Timer? _timer;

  void run(VoidCallback action) {
    dispose();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
