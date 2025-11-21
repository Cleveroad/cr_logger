import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/base/base_page_with_progress.dart';
import 'package:cr_logger/src/constants.dart';
import 'package:cr_logger/src/controllers/logs_mode.dart';
import 'package:cr_logger/src/extensions/do_post_frame.dart';
import 'package:cr_logger/src/managers/log_manager.dart';
import 'package:cr_logger/src/page/logs/log_local_detail_page.dart';
import 'package:cr_logger/src/page/widgets/local_log_item.dart';
import 'package:cr_logger/src/res/styles.dart';
import 'package:cr_logger/src/utils/show_remove_log_bottom_sheet.dart';
import 'package:cr_logger/src/utils/show_remove_log_snack_bar.dart';
import 'package:flutter/material.dart';

class LogPage extends StatefulWidget {
  const LogPage({
    required this.logType,
    this.onLogBeanSelected,
    super.key,
  });

  final LogType logType;
  final Function(LogBean logBean, LogType logType)? onLogBeanSelected;

  @override
  LogPageState createState() => LogPageState();
}

class LogPageState extends BasePageWithProgress<LogPage> {
  List<LogBean> _currentLogs = [];
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    LogManager.instance.onAllUpdate = getCurrentLogs;
    switch (widget.logType) {
      case LogType.http:
      case LogType.gql:
        break;
      case LogType.debug:
        LogManager.instance.onDebugUpdate = getCurrentLogs;
        break;
      case LogType.info:
        LogManager.instance.onInfoUpdate = getCurrentLogs;
        break;
      case LogType.error:
        LogManager.instance.onErrorUpdate = getCurrentLogs;
        break;
    }

    LogManager.instance.onLogsClear = _clearCurrentLogs;
    _scrollController.addListener(getCurrentLogs);

    getCurrentLogs();
  }

  @override
  void dispose() {
    LogManager.instance.onAllUpdate = null;
    switch (widget.logType) {
      case LogType.http:
      case LogType.gql:
        break;
      case LogType.debug:
        LogManager.instance.onDebugUpdate = null;
        break;
      case LogType.info:
        LogManager.instance.onInfoUpdate = null;
        break;
      case LogType.error:
        LogManager.instance.onErrorUpdate = null;
        break;
    }
    _scrollController
      ..removeListener(getCurrentLogs)
      ..dispose();
    super.dispose();
  }

  @override
  Widget bodyWidget(BuildContext context) {
    return Stack(
      children: [

        /// Log list
        ListView.separated(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(
            bottom: 24,
            left: 16,
            right: 16,
          ),
          itemCount: _currentLogs.length,
          itemBuilder: (_, index) {
            final item = _currentLogs[index];

            return LocalLogItem(
              key: ValueKey(item.id),
              logBean: item,
              logType: widget.logType,
              onSelected: _onLogBeanSelected,
              onRemove: _onRemoveLogPressed,
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 12),
        ),

        /// Placeholder
        if (_currentLogs.isEmpty)
          SizedBox(
            height: double.infinity,
            child: Center(
              child: Text(
                currentLogsMode == LogsMode.fromCurrentSession
                    ? 'No logs'
                    : 'No logs of previous sessions',
                style: CRStyle.bodyGreyMedium14,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Future<void> getCurrentLogs() async {
    switch (currentLogsMode) {
      case LogsMode.fromCurrentSession:
        _loadFromCurrentSession();
        break;
      case LogsMode.fromDB:
        _loadFromDB();
        break;
    }
    _update();
  }

  Future<void> _onLogBeanSelected(LogBean logBean) async {
    if (widget.onLogBeanSelected != null) {
      widget.onLogBeanSelected?.call(logBean, widget.logType);
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) =>
              LogLocalDetailPage(
                logBean: logBean,
                logType: widget.logType,
              ),
        ),
      );
    }
  }

  /// Refresh logs only when the page is scrolling at the start position
  void _loadFromCurrentSession() {
    var logs = <LogBean>[];
    switch (widget.logType) {
      case LogType.http:
      case LogType.gql:
        break;
      case LogType.debug:
        logs = LogManager.instance.logDebug.reversed.toList();
        break;
      case LogType.info:
        logs = LogManager.instance.logInfo.reversed.toList();
        break;
      case LogType.error:
        logs = LogManager.instance.logError.reversed.toList();
        break;
    }

    _updateContent(logs);
  }

  /// Refresh logs only when the page is scrolling at the start position
  void _loadFromDB() {
    var logs = <LogBean>[];
    switch (widget.logType) {
      case LogType.http:
      case LogType.gql:
        break;
      case LogType.debug:
        logs = LogManager.instance.logDebugDB.reversed.toList();
        break;
      case LogType.info:
        logs = LogManager.instance.logInfoDB.reversed.toList();
        break;
      case LogType.error:
        logs = LogManager.instance.logErrorDB.reversed.toList();
        break;
    }

    _updateContent(logs);
  }

  void _updateContent(List<LogBean> logs) {
    if (_scrollController.hasClients) {
      if (_scrollController.offset < kIndentForLoadingLogs) {
        _currentLogs = logs;
      }
    } else {
      /// doPostFrame is used to make the scrollController get listeners
      doPostFrame(() {
        _currentLogs = logs;
        _update();
      });
    }
  }

  Future<void> _onRemoveLogPressed(LogBean logBean) async {
    final okConfirmation = await showRemoveLogBottomSheet(
      context,
      message: logBean.message.toString(),
      textColor: logBean.color,
    );
    if (okConfirmation) {
      _removeLog(logBean);
      showRemoveLogSnackBar(context, () => _insertLog(logBean));
    }
  }

  void _clearCurrentLogs() {
    _currentLogs.clear();
    _update();
  }

  void _update() {
    if (mounted) {
      // ignore: no-empty-block
      setState(() {});
    }
  }

  void _removeLog(LogBean logBean) {
    LogManager.instance.removeLog(logBean);
    _currentLogs.removeWhere((element) => element.id == logBean.id);
  }

  Future<void> _insertLog(LogBean logBean) async {
    final logM = LogManager.instance;
    await logM.addLogToDB(logBean);

    if (_scrollController.hasClients &&
        _scrollController.offset > kIndentForLoadingLogs) {
      _currentLogs.insert(0, logBean);
      _currentLogs = logM.sortLogsByTime(_currentLogs);
    } else {
      switch (currentLogsMode) {
        case LogsMode.fromCurrentSession:
          logM.addLogToListByType(widget.logType, logBean);
          break;
        case LogsMode.fromDB:
          logM.addLogToDBListByType(widget.logType, logBean);
          break;
      }
    }

    _update();
  }
}
