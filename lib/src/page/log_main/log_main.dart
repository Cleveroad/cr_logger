import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/cr_logger_helper.dart';
import 'package:cr_logger/src/page/log_main/log_main_mobile.dart';
import 'package:cr_logger/src/page/log_main/log_main_web.dart';
import 'package:cr_logger/src/utils/local_log_managed.dart';
import 'package:cr_logger/src/widget/adaptive_layout/adaptive_layout_widget.dart';
import 'package:flutter/material.dart';

class MainLogPage extends StatefulWidget {
  const MainLogPage({Key? key}) : super(key: key);

  static void cleanLogs() {
    cleanDebug();
    cleanError();
    cleanInfo();
    cleanHttpLogs();
  }

  static void cleanHttpLogs() {
    HttpLogManager.instance.clear();
  }

  static void cleanDebug() {
    LocalLogManager.instance.cleanDebug();
  }

  static void cleanInfo() {
    LocalLogManager.instance.cleanInfo();
  }

  static void cleanError() {
    LocalLogManager.instance.cleanError();
  }

  @override
  _MainLogPageState createState() => _MainLogPageState();
}

class _MainLogPageState extends State<MainLogPage> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: CRLoggerHelper.instance.theme,
      child: const AdaptiveLayoutWidget(
        mobileLayoutWidget: MainLogMobilePage(),
        webLayoutWidget: MainLogWebPage(),
      ),
    );
  }
}
