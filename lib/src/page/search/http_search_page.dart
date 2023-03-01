import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/controllers/logs_mode_controller.dart';
import 'package:cr_logger/src/page/http_logs/http_log_details_page.dart';
import 'package:cr_logger/src/page/search/widgets/path_widget.dart';
import 'package:cr_logger/src/page/widgets/cupertino_search_field.dart';
import 'package:cr_logger/src/page/widgets/http_item.dart';
import 'package:cr_logger/src/res/styles.dart';
import 'package:cr_logger/src/utils/unfocus.dart';
import 'package:flutter/material.dart';

class HttpSearchPage extends StatefulWidget {
  const HttpSearchPage({super.key});

  @override
  State<HttpSearchPage> createState() => _HttpSearchPageState();
}

class _HttpSearchPageState extends State<HttpSearchPage> {
  final _results = <HttpBean>[];
  final _httpMng = HttpLogManager.instance;
  final _logsMode = LogsModeController.instance.logMode.value;
  final _searchCtrl = TextEditingController();

  bool get _isCurrentLogMode => _logsMode == LogsMode.fromCurrentSession;

  Set<String> _urls = {};

  @override
  void initState() {
    super.initState();
    _httpMng.onUpdate = _search;
    _urls = _httpMng.getAllRequests();
  }

  @override
  void dispose() {
    _httpMng.onUpdate = null;
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Search field
        SizedBox(
          height: 38,
          child: CupertinoSearchField(
            searchController: _searchCtrl,
            onSearch: () => _search(null),
            onClear: _clearResults,
            placeholderText: 'Enter the path of url',
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// The last 4 paths
                Wrap(
                  children: _urls
                      .map(
                        (path) => PathWidget(
                          onSearchUrl: () => _search(path),
                          path: path,
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                if (_results.isEmpty)

                  /// Empty State
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: const Center(
                      child: Text(
                        'No request log',
                        style: CRStyle.bodyGreyMedium14,
                      ),
                    ),
                  )
                else

                  /// List of HTTP request
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: _results.length,
                    itemBuilder: (_, index) {
                      final item = _results[index];

                      return HttpItem(
                        httpBean: item,
                        onSelected: _onHttpBeanSelected,
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// To find the correct logs. If user click on the path,
  /// it will search that path, otherwise it will search the text from the search field
  void _search(String? uriPath) {
    final query = _searchCtrl.text.trim().toLowerCase();
    final logs = _isCurrentLogMode ? _httpMng.logValues() : _httpMng.logsFromDB;
    final searchedLogs = logs.where((log) {
      final url = log.request?.url;

      if (url != null && uriPath != null) {
        return url.contains(uriPath);
      } else {
        if (url != null) {
          final path = Uri.parse(url).path;

          return path.contains(query);
        }
      }

      return false;
    }).toList();

    if (query.isNotEmpty || uriPath != null) {
      setState(() {
        _results
          ..clear()
          ..addAll(searchedLogs.reversed);
      });
    } else {
      setState(_results.clear);
    }
  }

  /// Clicking on the log opens the details page
  Future<void> _onHttpBeanSelected(HttpBean bean) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => HttpLogDetailsPage(bean),
      ),
    );
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
