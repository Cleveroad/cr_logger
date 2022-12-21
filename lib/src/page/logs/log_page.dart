import 'package:cr_logger/src/base/base_page_with_progress.dart';
import 'package:cr_logger/src/controllers/logs_mode_controller.dart';
import 'package:cr_logger/src/data/bean/log_bean.dart';
import 'package:cr_logger/src/data/models/log_type.dart';
import 'package:cr_logger/src/extensions/do_post_frame.dart';
import 'package:cr_logger/src/managers/log_manager.dart';
import 'package:cr_logger/src/page/logs/log_local_detail_page.dart';
import 'package:cr_logger/src/page/widgets/local_log_item.dart';
import 'package:cr_logger/src/res/styles.dart';
import 'package:flutter/material.dart';

class LogPage extends StatefulWidget {
  const LogPage({
    required this.logType,
    this.onLogBeanSelected,
    this.scrollController,
    super.key,
  });

  final LogType logType;
  final Function(LogBean logBean, LogType logType)? onLogBeanSelected;
  final ScrollController? scrollController;

  @override
  LogPageState createState() => LogPageState();
}

class LogPageState extends BasePageWithProgress<LogPage> {
  List<LogBean> _currentLogs = [];

  @override
  void initState() {
    super.initState();
    LogManager.instance.onAllUpdate = getCurrentLogs;
    switch (widget.logType) {
      case LogType.http:
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
    LogManager.instance.onAllUpdate?.call();
  }

  @override
  void dispose() {
    LogManager.instance.onAllUpdate = null;
    switch (widget.logType) {
      case LogType.http:
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
    super.dispose();
  }

  @override
  Widget bodyWidget(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _currentLogs.isEmpty
              ? const SizedBox(
                  height: double.infinity,
                  child: Center(
                    child: Text(
                      'No logs',
                      style: CRStyle.bodyGreyMedium14,
                    ),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        controller: widget.scrollController,
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
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                      ),
                    ),
                  ],
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
          builder: (ctx) => LogLocalDetailPage(
            logBean: logBean,
            logType: widget.logType,
          ),
        ),
      );
    }
  }

  void _loadFromCurrentSession() {
    switch (widget.logType) {
      case LogType.http:
        break;
      case LogType.debug:
        _currentLogs = LogManager.instance.logDebug.reversed.toList();
        break;
      case LogType.info:
        _currentLogs = LogManager.instance.logInfo.reversed.toList();
        break;
      case LogType.error:
        _currentLogs = LogManager.instance.logError.reversed.toList();
        break;
    }
  }

  void _loadFromDB() {
    switch (widget.logType) {
      case LogType.http:
        break;
      case LogType.debug:
        _currentLogs = LogManager.instance.logDebugDB.reversed.toList();
        break;
      case LogType.info:
        _currentLogs = LogManager.instance.logInfoDB.reversed.toList();
        break;
      case LogType.error:
        _currentLogs = LogManager.instance.logErrorDB.reversed.toList();
        break;
    }
  }

  void _update() => doPostFrame(() {
        if (mounted) {
          // ignore: no-empty-block
          setState(() {});
        }
      });
}
