import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chopper/chopper.dart' as chopper;
import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger_example/generated/assets.dart';
import 'package:cr_logger_example/rest_client.dart';
import 'package:cr_logger_example/widgets/example_btn.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:share_plus/share_plus.dart';

Future<void> main() async {
  // Call this first if main function is async
  WidgetsFlutterBinding.ensureInitialized();

  // First! Initialize logger
  await CRLoggerInitializer.instance.init(
    useDatabase: true,
    theme: ThemeData.light(),
    levelColors: {
      Level.debug: Colors.lightGreenAccent,
      Level.warning: Colors.orange,
      Level.trace: Colors.blueAccent,
      Level.info: Colors.blueAccent,
      Level.error: Colors.red,
      Level.fatal: Colors.red.shade900,
      Level.off: Colors.grey.shade300,
    },
    hiddenFields: [
      'Test',
      'Test3',
      'Test7',
      'freeform',
      'qwe',
    ],
    hiddenHeaders: [
      'content-type',
      'Test3',
      'Authorization',
    ],
    logFileName: 'my_logs',

    /// To display logs in our web example on pub.dev
    /// https://cleveroad.github.io/cr_logger/#/
    useCrLoggerInReleaseBuild: !kReleaseMode,
  );

  // Second! Define the variables
  CRLoggerInitializer.instance.appInfo = {
    'Build type': 'release',
    'Endpoint': 'https/cr_logger/example/',
  };

  final proxy = CRLoggerInitializer.instance.getProxySettings();
  if (proxy != null) {
    RestClient.instance.initDioProxyForCharles(proxy);
  }

  CRLoggerInitializer.instance.onShareLogsFile = (String path) async {
    await Share.shareXFiles([XFile(path)]);
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  const MainPage({super.key});

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
    final doubleNotifier = ValueNotifier<double>(0);
    final boolNotifier = ValueNotifier<bool>(false);
    final stringNotifier = ValueNotifier<String>('integer: ');

    /// Widget notifiers
    final iconNotifier = ValueNotifier<IconData>(Icons.clear);
    final iconWidget = ValueListenableBuilder<IconData>(
      valueListenable: iconNotifier,
      //ignore: prefer-trailing-comma
      builder: (_, value, __) => Row(
        children: [
          const Text('Icon'),
          const Spacer(),
          Icon(value),
          const Spacer(),
        ],
      ),
    );
    final textNotifier = ValueNotifier<Text>(
      const Text('Widget text'),
    );
    final textWidget = ValueListenableBuilder<Text>(
      valueListenable: textNotifier,
      //ignore: prefer-trailing-comma
      builder: (_, value, __) => Row(
        children: [
          const Text('Icon'),
          const Spacer(),
          value,
          const Spacer(),
        ],
      ),
    );

    final integerNotifier = ValueNotifier<int>(0);
    final intWidget = ValueListenableBuilder<int>(
      valueListenable: integerNotifier,
      //ignore: prefer-trailing-comma
      builder: (_, value, __) => Text('Int: ${value.toString()}'),
    );
    final boolWithWidgetNotifier = ValueNotifier<bool>(false);

    final boolWidget = ValueListenableBuilder<bool>(
      valueListenable: boolWithWidgetNotifier,
      //ignore: prefer-trailing-comma
      builder: (_, value, __) => SwitchListTile(
        title: const Text('Bool'),
        subtitle: Text(value.toString()),
        value: value,
        onChanged: (newValue) => boolWithWidgetNotifier.value = newValue,
      ),
    );

    /// Type notifiers changes
    Timer.periodic(const Duration(seconds: 1), (_) => integerNotifier.value++);
    //ignore: prefer-extracting-callbacks
    Timer.periodic(
      const Duration(milliseconds: 1),
      (_) => doubleNotifier
        ..value += 0.1
        ..value = double.parse(doubleNotifier.value.toStringAsFixed(3)),
    );
    Timer.periodic(
      const Duration(seconds: 1),
      (_) => boolNotifier.value = !boolNotifier.value,
    );
    Timer.periodic(
      const Duration(seconds: 1),
      (_) => stringNotifier.value = 'number: ${integerNotifier.value}',
    );

    /// Widget notifiers changes
    Timer.periodic(
      const Duration(seconds: 1),
      (_) => Icon(boolNotifier.value
          ? Icons.airline_seat_flat
          : Icons.airline_seat_flat_angled),
    );

    Timer.periodic(
      const Duration(seconds: 1),
      (_) => iconNotifier.value = boolNotifier.value
          ? Icons.airline_seat_flat
          : Icons.airline_seat_flat_angled,
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

    /// If the widget is not defined, then the name and the value will be used.
    CRLoggerInitializer.instance.addValueNotifier(
      widget: intWidget,
    );

    CRLoggerInitializer.instance.addValueNotifier(
      widget: boolWidget,
    );

    CRLoggerInitializer.instance.addValueNotifier(
      name: 'Double',
      notifier: doubleNotifier,
    );
    CRLoggerInitializer.instance.addValueNotifier(
      name: 'Bool',
      notifier: boolNotifier,
    );
    CRLoggerInitializer.instance.addValueNotifier(
      name: 'String',
      notifier: stringNotifier,
    );
    CRLoggerInitializer.instance.addValueNotifier(
      widget: iconWidget,
    );
    CRLoggerInitializer.instance.addValueNotifier(
      widget: textWidget,
    );

    /// Actions
    CRLoggerInitializer.instance.addActionButton('Log Hi', () => log.i('Hi'));
    CRLoggerInitializer.instance.addActionButton('Log By', () => log.i('By'));

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
                                  onHover: _onHover,
                                  onLeave: _onLeave,
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
                            backgroundColor: Colors.blueGrey,
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

  void _onHover() {
    _debouncer.dispose();
    if (!_dragging) {
      setState(() => _dragging = true);
    }
  }

  void _onLeave() {
    _debouncer.run(() {
      setState(() => _dragging = false);
    });
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

  /// Examples of http request with logger interceptor
  Future<void> _makeHttpRequest() async {
    /// Request example for dio package
    await _makeDioHttpRequest();

    /// Request example for chopper package
    //await _makeChopperHttpRequest();

    /// Request example for http package
    //await _makeRegularHttpRequest();

    /// Request example for dart:io library
    //await _makeHttpClientRequest();
  }

  Future<void> _makeDioHttpRequest() async {
    final queryParameters = <String, dynamic>{
      'freeform': 'test',
      'testParameter': 'test',
    };

    await RestClient.instance.dio.post(
      'https://httpbin.org/anything',
      queryParameters: queryParameters,
      data: {
        'Test': '1',
        'Test2': {
          'Test': [
            {'Test': 'qwe'},
            {'Test': 'qwe'},
          ],
        },
        'Test5': {
          'Test9': [
            {'name': 'qwe'},
            {'Test7': 'qwe'},
          ],
        },
        'Test3': {'qwe': 1},
        'Test4': {'qwe': 1},
      },
      options: dio.Options(
        headers: {
          'Authorization': 'qwewrrq',
          'Test3': 'qwewrrq',
        },
      ),
    );
  }

  //ignore: unused_element
  Future<void> _makeRegularHttpRequest() async {
    final url = Uri.parse('https://httpbin.org/anything');
    const body = {'Test': '1', 'Test2': 'qwe'};

    /// In case there is no internet, the http request will throw
    /// a SocketException and the logger will not record anything.
    /// You can wrap the request in a try catch block and log the error yourself
    try {
      final response = await http.post(url, body: body);
      CRLoggerInitializer.instance.onHttpResponse(response, body);
    } on SocketException catch (error) {
      log.e(error.message);
    }
  }

  //ignore: unused_element
  Future<void> _makeHttpClientRequest() async {
    final url = Uri.parse('https://httpbin.org/anything');
    const body = {'Test': '1', 'Test2': 'qwe'};

    /// In case there is no internet, the http request will throw
    /// a SocketException and the logger will not record anything.
    /// You can wrap the request in a try catch block and log the error yourself
    final client = HttpClient();
    try {
      final request = await client.postUrl(url);
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        'application/json; charset=UTF-8',
      );
      request.write('{"title": "Foo","body": "Bar", "userId": 99}');
      CRLoggerInitializer.instance.onHttpClientRequest(request, body);

      final response = await request.close();
      CRLoggerInitializer.instance.onHttpClientResponse(
        response,
        request,
        body,
      );
    } on SocketException catch (error) {
      log.e(error.message);
    }
  }

  //ignore: unused_element
  Future<void> _makeChopperHttpRequest() async {
    /// In case there is no internet, the chopper will log a request, then it
    /// will receive a SocketException and will not log a response.
    /// This causes the request to remain in "Sending" status in the logger
    await RestClient.instance.chopper.send(chopper.Request(
      'POST',
      Uri.parse('https://httpbin.org/anything'),
      Uri.parse(''),
      headers: {
        'Authorization': 'qwewrrq',
        'Test3': 'qwewrrq',
      },
      body: {'Test': '1', 'Test2': 'qwe'},
    ));
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
      ..t('Verbose message at ${DateTime.now().toIso8601String()}');
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
      },
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
      ..e(
        'Error message at ${DateTime.now().toIso8601String()}',
        error: const HttpException('message'),
      )
      ..f('Wtf message at ${DateTime.now().toIso8601String()}');
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
