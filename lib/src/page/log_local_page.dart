import 'package:cr_logger/src/bean/log_bean.dart';
import 'package:cr_logger/src/bean/log_type.dart';
import 'package:cr_logger/src/page/log_local_detail_page.dart';
import 'package:cr_logger/src/page/widgets/local_log_item.dart';
import 'package:cr_logger/src/styles.dart';
import 'package:cr_logger/src/utils/local_log_managed.dart';
import 'package:flutter/material.dart';

class LocalLogsPage extends StatefulWidget {
  const LocalLogsPage({
    required this.logType,
    this.onLogBeanSelected,
    this.scrollController,
    super.key,
  });

  final LogType logType;
  final Function(LogBean logBean, LogType logType)? onLogBeanSelected;
  final ScrollController? scrollController;

  @override
  LocalLogsPageState createState() => LocalLogsPageState();
}

class LocalLogsPageState extends State<LocalLogsPage> {
  List<LogBean> logs = [];

  @override
  void dispose() {
    switch (widget.logType) {
      case LogType.http:
        break;
      case LogType.debug:
        LocalLogManager.instance.onDebugUpdate = null;
        break;
      case LogType.info:
        LocalLogManager.instance.onInfoUpdate = null;
        break;
      case LogType.error:
        LocalLogManager.instance.onErrorUpdate = null;
        break;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _initListData();

    return Row(
      children: [
        Expanded(
          child: logs.isEmpty
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
                        itemCount: logs.length,
                        itemBuilder: (_, index) {
                          final item = logs[index];

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

  void _initListData() {
    switch (widget.logType) {
      case LogType.http:
        break;
      case LogType.debug:
        logs = LocalLogManager.instance.logDebug.reversed.toList();
        LocalLogManager.instance.onDebugUpdate = _update;
        break;
      case LogType.info:
        logs = LocalLogManager.instance.logInfo.reversed.toList();
        LocalLogManager.instance.onInfoUpdate = _update;
        break;
      case LogType.error:
        logs = LocalLogManager.instance.logError.reversed.toList();
        LocalLogManager.instance.onErrorUpdate = _update;
        break;
    }
  }

  void _update() {
    // ignore: no-empty-block
    setState(() {});
  }
}
