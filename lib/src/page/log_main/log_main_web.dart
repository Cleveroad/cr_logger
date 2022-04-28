import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/colors.dart';
import 'package:cr_logger/src/cr_logger_helper.dart';
import 'package:cr_logger/src/extensions/do_post_frame.dart';
import 'package:cr_logger/src/page/http_log_details_page.dart';
import 'package:cr_logger/src/page/http_logs_page.dart';
import 'package:cr_logger/src/page/log_local_detail_page.dart';
import 'package:cr_logger/src/page/log_local_page.dart';
import 'package:cr_logger/src/page/log_main/widgets/cr_web_appbar_widget.dart';
import 'package:cr_logger/src/page/log_main/widgets/web_header_widget.dart';
import 'package:cr_logger/src/utils/local_log_managed.dart';
import 'package:cr_logger/src/widget/options_buttons.dart';
import 'package:flutter/material.dart';
import 'package:split_view/split_view.dart';

class MainLogWebPage extends StatefulWidget {
  const MainLogWebPage({required this.onLoggerClose, Key? key})
      : super(key: key);

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
  _MainLogWebPageState createState() => _MainLogWebPageState();
}

class _MainLogWebPageState extends State<MainLogWebPage> {
  final _pageController = PageController();
  final _detailsScrollControler = ScrollController();
  final _pageScrollControler = ScrollController();

  final _popupKey = GlobalKey<PopupMenuButtonState>();
  final _navKey = GlobalKey<OptionsButtonsState>();

  final _httpLogKey = GlobalKey<HttpLogsPageState>();
  final _debugLogKey = GlobalKey<LocalLogsPageState>();
  final _infoLogKey = GlobalKey<LocalLogsPageState>();
  final _errorLogKey = GlobalKey<LocalLogsPageState>();

  late List<Widget> tabPages;

  LogType _currentLogType = LogType.http;

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
        scrollController: _pageScrollControler,
      ),
      LocalLogsPage(
        key: _debugLogKey,
        logType: LogType.debug,
        onLogBeanSelected: _onLogBeanSelected,
        scrollController: _pageScrollControler,
      ),
      LocalLogsPage(
        key: _infoLogKey,
        logType: LogType.info,
        onLogBeanSelected: _onLogBeanSelected,
        scrollController: _pageScrollControler,
      ),
      LocalLogsPage(
        key: _errorLogKey,
        logType: LogType.error,
        onLogBeanSelected: _onLogBeanSelected,
        scrollController: _pageScrollControler,
      ),
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
                          LogType.http.asString(),
                          LogType.debug.asString(),
                          LogType.info.asString(),
                          LogType.error.asString(),
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
                    weights: [
                      0.6,
                      0.4,
                    ],
                  ),
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
                      child: _httpBean != null
                          ? HttpLogDetailsPage(
                              _httpBean!,
                              isWeb: true,
                            )
                          : _logBean != null
                              ? Scrollbar(
                                  controller: _detailsScrollControler,
                                  child: LogLocalDetailPage(
                                    scrollController: _detailsScrollControler,
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
}
