import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/colors.dart';
import 'package:cr_logger/src/cr_logger_helper.dart';
import 'package:cr_logger/src/page/log_local_detail_page.dart';
import 'package:cr_logger/src/page/widgets/search/search_item.dart';
import 'package:cr_logger/src/utils/local_log_managed.dart';
import 'package:cr_logger/src/widget/cr_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LogSearchPage extends StatefulWidget {
  const LogSearchPage({Key? key}) : super(key: key);

  @override
  _LogSearchPageState createState() => _LogSearchPageState();
}

class _LogSearchPageState extends State<LogSearchPage> {
  final _searchCtrl = TextEditingController();

  final _results = <LogBean>[];

  final _logMng = LocalLogManager.instance;

  @override
  void initState() {
    super.initState();
    LocalLogManager.instance.onAllUpdate = _search;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    LocalLogManager.instance.onAllUpdate = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Theme(
        data: CRLoggerHelper.instance.theme,
        child: Scaffold(
          backgroundColor: CRLoggerColors.backgroundGrey,
          appBar: AppBar(
            leading: const CRBackButton(),
            elevation: 0,
            backgroundColor: CRLoggerColors.backgroundGrey,
            title: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    onChanged: (_) => _search(),
                    controller: _searchCtrl,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(),
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: CRLoggerColors.black,
                  ),
                  onPressed: _clearResults,
                ),
              ],
            ),
          ),
          body: _results.isEmpty
              ? const Center(
                  child: Text('Search is empty'),
                )
              : ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (_, index) => SearchItem(
                    logBean: _results[index],
                    onTap: _onItemTap,
                    onLongTap: _onItemLongTap,
                  ),
                ),
        ),
      );

  void _clearResults() {
    FocusScope.of(context).unfocus();
    setState(() {
      _searchCtrl.clear();
      _results.clear();
    });
  }

  void _search() {
    final query = _searchCtrl.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      setState(() {
        _results
          ..clear()
          ..addAll(_logMng.logDebug.reversed
              .where((log) => log.message.toLowerCase().contains(query)))
          ..addAll(_logMng.logInfo.reversed
              .where((log) => log.message.toLowerCase().contains(query)))
          ..addAll(_logMng.logError.reversed
              .where((log) => log.message.toLowerCase().contains(query)))
          ..sort((a, b) => a.compareTo(b));
      });
    }
  }

  Future<void> _onItemTap(LogBean bean) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => LogLocalDetailPage(logBean: bean),
      ),
    );
  }

  Future<void> _onItemLongTap(LogBean bean) async {
    try {
      await Clipboard.setData(ClipboardData(text: bean.message));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Copy \n"${bean.message}"',
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    } catch (error, stackTrace) {
      log.e(
        'Internal logger error',
        error,
        stackTrace,
      );
    }
  }
}
