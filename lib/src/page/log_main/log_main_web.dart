import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/cr_logger_helper.dart';
import 'package:cr_logger/src/extensions/do_post_frame.dart';
import 'package:cr_logger/src/managers/log_manager.dart';
import 'package:cr_logger/src/page/http_logs/http_log_details_page.dart';
import 'package:cr_logger/src/page/http_logs/http_logs_page.dart';
import 'package:cr_logger/src/page/log_main/widgets/cr_web_appbar_widget.dart';
import 'package:cr_logger/src/page/log_main/widgets/web_header_widget.dart';
import 'package:cr_logger/src/page/logs/log_local_detail_page.dart';
import 'package:cr_logger/src/page/logs/log_page.dart';
import 'package:cr_logger/src/res/colors.dart';
import 'package:cr_logger/src/widget/options_buttons.dart';
import 'package:flutter/material.dart';
import 'package:split_view/split_view.dart';

class MainLogWebPage extends StatefulWidget {
  const MainLogWebPage({required this.onLoggerClose, super.key});

  final VoidCallback onLoggerClose;

  static void cleanLogs() {
    LogManager.instance.clean();
  }

  static void cleanHttpLogs() {
    HttpLogManager.instance.cleanAllLogs();
  }

  static void cleanDebug() {
    LogManager.instance.cleanDebug();
  }

  static void cleanInfo() {
    LogManager.instance.cleanInfo();
  }

  static void cleanError() {
    LogManager.instance.cleanError();
  }

  @override
  _MainLogWebPageState createState() => _MainLogWebPageState();
}

class _MainLogWebPageState extends State<MainLogWebPage> {
  final _pageController = PageController();
  final _detailsScrollCtr = ScrollController();

  final _popupKey = GlobalKey<PopupMenuButtonState>();
  final _navKey = GlobalKey<OptionsButtonsState>();

  final _httpLogKey = GlobalKey<HttpLogsPageState>();
  final _debugLogKey = GlobalKey<LogPageState>();
  final _infoLogKey = GlobalKey<LogPageState>();
  final _errorLogKey = GlobalKey<LogPageState>();

  late List<Widget> tabPages;

  LogType _currentLogType = LogType.http;
  List<double?> _splitWeights = [0.6, 0.4];

  HttpBean? _httpBean;
  LogBean? _logBean;
  LogType? _logType;

  @override
  void initState() {
    super.initState();
    tabPages = [
      HttpLogsPage(
        key: _httpLogKey,
        onHttpBeanSelected: _onHttpBeanSelected,
      ),
      LogPage(
        key: _debugLogKey,
        logType: LogType.debug,
        onLogBeanSelected: _onLogBeanSelected,
      ),
      LogPage(
        key: _infoLogKey,
        logType: LogType.info,
        onLogBeanSelected: _onLogBeanSelected,
      ),
      LogPage(
        key: _errorLogKey,
        logType: LogType.error,
        onLogBeanSelected: _onLogBeanSelected,
      ),
    ];
    _pageController.addListener(_onPageChanged);

    LogManager.instance.logToastNotifier.addListener(_openLogDetails);
    WidgetsBinding.instance.addPostFrameCallback((_) => _openLogDetails());
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    LogManager.instance.logToastNotifier.removeListener(_openLogDetails);
    _detailsScrollCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final httpBean = _httpBean;

    return Theme(
      data: CRLoggerHelper.instance.theme,
      child: Scaffold(
        backgroundColor: CRLoggerColors.backgroundGrey,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 32,
                right: 32,
                bottom: 16,
              ),
              child: Column(
                children: [
                  Column(
                    children: [
                      CRWebAppBar(
                        popupKey: _popupKey,
                        onLoggerClose: widget.onLoggerClose,
                      ),
                      OptionsButtons(
                        key: _navKey,
                        isWeb: true,
                        titles: [
                          LogType.http.name,
                          LogType.debug.name,
                          LogType.info.name,
                          LogType.error.name,
                        ],
                        onSelected: _onOptionSelected,
                      ),
                      const SizedBox(height: 16),
                      WebHeaderWidget(
                        onClear: _onClear,
                        onAllClear: _onAllClear,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: SplitView(
                  gripColor: CRLoggerColors.backgroundGrey,
                  gripColorActive: CRLoggerColors.backgroundGrey,
                  viewMode: SplitViewMode.Horizontal,
                  indicator: const SplitIndicator(
                    viewMode: SplitViewMode.Horizontal,
                    color: CRLoggerColors.whitish,
                  ),
                  activeIndicator: const SplitIndicator(
                    viewMode: SplitViewMode.Horizontal,
                    isActive: true,
                    color: CRLoggerColors.blue,
                  ),
                  controller: SplitViewController(
                    limits: [
                      WeightLimit(min: 0.3),
                      WeightLimit(min: 0.3),
                    ],
                    weights: _splitWeights,
                  ),
                  onWeightChanged: (weights) => _splitWeights = weights,
                  children: [
                    PageView(
                      controller: _pageController,
                      children: tabPages,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: CRLoggerColors.whitish,
                        ),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: httpBean != null
                          ? HttpLogDetailsPage(
                              httpBean,
                              isWeb: true,
                            )
                          : _logBean != null
                              ? Scrollbar(
                                  controller: _detailsScrollCtr,
                                  child: LogLocalDetailPage(
                                    scrollController: _detailsScrollCtr,
                                    logBean: _logBean,
                                    logType: _logType,
                                    isWeb: true,
                                  ),
                                )
                              : const SizedBox(
                                  height: double.infinity,
                                ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onAllClear() {
    LogManager.instance.clean();
    HttpLogManager.instance.cleanAllLogs();
    _updatePages();
  }

  void _onClear() {
    switch (_currentLogType) {
      case LogType.debug:
        LogManager.instance.logDebug.clear();
        break;
      case LogType.info:
        LogManager.instance.logInfo.clear();
        break;
      case LogType.error:
        LogManager.instance.logError.clear();
        break;
      case LogType.http:
        HttpLogManager.instance.cleanAllLogs();
        break;
    }
    _updatePages();
  }

  void _updatePages() {
    setState(() {
      _httpBean = null;
      _logBean = null;
    });
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

  void _onHttpBeanSelected(HttpBean httpBean) {
    setState(() {
      _logBean = null;
      _httpBean = httpBean;
    });
  }

  void _onLogBeanSelected(LogBean logBean, LogType logType) {
    setState(() {
      _httpBean = null;
      _logBean = logBean;
      _logType = logType;
    });
  }

  void _onOptionSelected(int index) {
    _currentLogType = LogType.values[index];
    _pageController.jumpToPage(index);
  }

  /// Opens a tab according to the type of log
  /// Opens the log details page
  Future<void> _openLogDetails() async {
    final log = LogManager.instance.logToastNotifier.value;
    final logType = log?.type;

    if (logType != null && log != null) {
      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (ctx) => LogLocalDetailPage(
            logBean: log,
            logType: logType,
          ),
        ),
        (Route<dynamic> route) => route.settings.name == '/',
      );

      _pageController.jumpToPage(logType.index);
      LogManager.instance.logToastNotifier.value = null;
    }
  }
}
