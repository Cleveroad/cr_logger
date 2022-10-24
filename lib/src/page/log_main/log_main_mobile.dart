import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/generated/assets.dart';
import 'package:cr_logger/src/colors.dart';
import 'package:cr_logger/src/cr_logger_helper.dart';
import 'package:cr_logger/src/extensions/do_post_frame.dart';
import 'package:cr_logger/src/extensions/extensions.dart';
import 'package:cr_logger/src/page/http_logs_page.dart';
import 'package:cr_logger/src/page/log_local_page.dart';
import 'package:cr_logger/src/page/log_main/widgets/mobile_header_widget.dart';
import 'package:cr_logger/src/page/widgets/popup_menu.dart';
import 'package:cr_logger/src/utils/local_log_managed.dart';
import 'package:cr_logger/src/widget/cr_app_bar.dart';
import 'package:cr_logger/src/widget/options_buttons.dart';
import 'package:flutter/material.dart';

class MainLogMobilePage extends StatefulWidget {
  const MainLogMobilePage({
    required this.onLoggerClose,
    super.key,
  });

  final VoidCallback onLoggerClose;

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
  _MainLogMobilePageState createState() => _MainLogMobilePageState();
}

class _MainLogMobilePageState extends State<MainLogMobilePage> {
  final _pageController = PageController();

  final _popupKey = GlobalKey<PopupMenuButtonState>();
  final _navKey = GlobalKey<OptionsButtonsState>();

  final _httpLogKey = GlobalKey<HttpLogsPageState>();
  final _debugLogKey = GlobalKey<LocalLogsPageState>();
  final _infoLogKey = GlobalKey<LocalLogsPageState>();
  final _errorLogKey = GlobalKey<LocalLogsPageState>();

  late List<Widget> tabPages;

  LogType _currentLogType = LogType.http;

  @override
  void initState() {
    super.initState();
    tabPages = [
      HttpLogsPage(key: _httpLogKey),
      LocalLogsPage(key: _debugLogKey, logType: LogType.debug),
      LocalLogsPage(key: _infoLogKey, logType: LogType.info),
      LocalLogsPage(key: _errorLogKey, logType: LogType.error),
    ];
    _pageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: CRLoggerHelper.instance.theme,
      child: Scaffold(
        backgroundColor: CRLoggerColors.backgroundGrey,
        appBar: CRAppBar(
          showLoggerVersion: true,
          onBackPressed: widget.onLoggerClose,
          showBackButton: true,
          actions: [
            PopupMenu(
              popupKey: _popupKey,
              child: IconButton(
                onPressed: () => _popupKey.currentState?.showButtonMenu(),
                icon: ImageExt.fromPackage(CRLoggerAssets.assetsIcMenu),
              ),
            ),
          ],
        ),
        body: Container(
          color: CRLoggerColors.backgroundGrey,
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    OptionsButtons(
                      key: _navKey,
                      titles: [
                        LogType.http.asString(),
                        LogType.debug.asString(),
                        LogType.info.asString(),
                        LogType.error.asString(),
                      ],
                      onSelected: _onOptionSelected,
                    ),
                    const SizedBox(height: 16),
                    MobileHeaderWidget(
                      onClear: _onClear,
                      onAllClear: _onAllClear,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  children: tabPages,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onAllClear() {
    LocalLogManager.instance.clean();
    HttpLogManager.instance.clear();
    _updatePages();
  }

  void _onClear() {
    switch (_currentLogType) {
      case LogType.debug:
        LocalLogManager.instance.logDebug.clear();
        break;
      case LogType.info:
        LocalLogManager.instance.logInfo.clear();
        break;
      case LogType.error:
        LocalLogManager.instance.logError.clear();
        break;
      case LogType.http:
        HttpLogManager.instance.clear();
        break;
    }
    _updatePages();
  }

  void _updatePages() {
    doPostFrame(() {
      (tabPages[_currentLogType.index].key as GlobalKey)
          .currentState
          // ignore: no-empty-block
          ?.setState(() {});
    });
  }

  void _onPageChanged() {
    _currentLogType = LogType.values[_pageController.page?.round() ?? 0];
    _navKey.currentState?.change(_currentLogType.index);
  }

  void _onOptionSelected(int index) {
    _currentLogType = LogType.values[index];
    _pageController.jumpToPage(index);
  }
}
