import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/controllers/logs_mode_controller.dart';
import 'package:cr_logger/src/managers/log_manager.dart';
import 'package:cr_logger/src/page/logs/log_local_detail_page.dart';
import 'package:cr_logger/src/page/widgets/cupertino_search_field.dart';
import 'package:cr_logger/src/page/widgets/local_log_item.dart';
import 'package:cr_logger/src/res/styles.dart';
import 'package:cr_logger/src/utils/pair.dart';
import 'package:cr_logger/src/utils/unfocus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LogSearchPage extends StatefulWidget {
  const LogSearchPage({super.key});

  @override
  State<LogSearchPage> createState() => _LogSearchPageState();
}

class _LogSearchPageState extends State<LogSearchPage> {
  final _results = <Pair<LogType, LogBean>>[];
  final _logMng = LogManager.instance;
  final _logsMode = LogsModeController.instance.logMode.value;
  final _searchCtrl = TextEditingController();

  bool get _isCurrentLogMode => _logsMode == LogsMode.fromCurrentSession;

  @override
  void initState() {
    super.initState();
    LogManager.instance.onAllUpdate = _search;
  }

  @override
  void dispose() {
    LogManager.instance.onAllUpdate = null;
    _searchCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Search field
        SizedBox(
          height: 38,
          child: CupertinoSearchField(
            searchController: _searchCtrl,
            onSearch: _search,
            onClear: _clearResults,
            placeholderText: 'Enter log',
          ),
        ),
        const SizedBox(height: 24),
        if (_results.isEmpty)

          /// Empty state
          const Expanded(
            child: Center(
              child: Text(
                'No logs',
                style: CRStyle.bodyGreyMedium14,
              ),
            ),
          )
        else

          /// List of logs
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _results.length,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                bottom: 24,
                right: 16,
                left: 16,
              ),
              itemBuilder: (_, index) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Log type label
                  Text(
                    _results[index].first.name,
                    style: CRStyle.bodyGreyRegular14,
                  ),
                  const SizedBox(height: 4),

                  /// Log
                  LocalLogItem(
                    logBean: _results[index].second,
                    logType: _results[index].first,
                    onSelected: (bean) =>
                        _onItemTap(bean, _results[index].first),
                    onLongTap: _onItemLongTap,
                  ),
                ],
              ),
              separatorBuilder: (_, __) => const SizedBox(height: 18),
            ),
          ),
      ],
    );
  }

  /// The search goes through the logs message. Also looking at the logs mode searches the list
  void _search() {
    final query = _searchCtrl.text.trim().toLowerCase();
    final logsDebug = _isCurrentLogMode ? _logMng.logDebug : _logMng.logDebugDB;
    final logsInfo = _isCurrentLogMode ? _logMng.logInfo : _logMng.logInfoDB;
    final logsError = _isCurrentLogMode ? _logMng.logError : _logMng.logErrorDB;
    if (query.isNotEmpty) {
      setState(() {
        _results
          ..clear()
          ..addAll(
            logsDebug.reversed
                .where(
                  (log) => log.message.toString().toLowerCase().contains(query),
                )
                .map(
                  (e) => Pair(first: LogType.debug, second: e),
                ),
          )
          ..addAll(
            logsInfo.reversed
                .where((log) =>
                    log.message.toString().toLowerCase().contains(query))
                .map(
                  (e) => Pair(first: LogType.info, second: e),
                ),
          )
          ..addAll(
            logsError.reversed
                .where((log) =>
                    log.message.toString().toLowerCase().contains(query))
                .map(
                  (e) => Pair(first: LogType.error, second: e),
                ),
          )
          ..sort((a, b) => a.second.compareTo(b.second));
      });
    } else {
      setState(_results.clear);
    }
  }

  /// Clicking on the log opens the details page
  Future<void> _onItemTap(LogBean bean, LogType type) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => LogLocalDetailPage(
          logBean: bean,
          logType: type,
        ),
      ),
    );
  }

  /// Long Clicking on the log copy this log to clipboard
  Future<void> _onItemLongTap(LogBean bean) async {
    try {
      final beanMessage = bean.message.toString();
      await Clipboard.setData(ClipboardData(text: beanMessage));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Copy \n"$beanMessage"',
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    } catch (error, stackTrace) {
      log.e(
        'Internal logger error',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Clear search field and all logs on the page
  void _clearResults() {
    unfocus();
    setState(() {
      _searchCtrl.clear();
      _results.clear();
    });
  }
}
