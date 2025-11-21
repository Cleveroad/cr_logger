import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/base/base_page_with_progress.dart';
import 'package:cr_logger/src/controllers/logs_mode.dart';
import 'package:cr_logger/src/page/http_logs/http_log_details_page.dart';
import 'package:cr_logger/src/page/widgets/http_item.dart';
import 'package:cr_logger/src/res/styles.dart';
import 'package:cr_logger/src/utils/show_remove_log_bottom_sheet.dart';
import 'package:cr_logger/src/utils/show_remove_log_snack_bar.dart';
import 'package:flutter/material.dart';

class HttpLogsPage extends StatefulWidget {
  const HttpLogsPage({
    this.onHttpBeanSelected,
    super.key,
  });

  final Function(HttpBean httpBean)? onHttpBeanSelected;

  @override
  State<HttpLogsPage> createState() => HttpLogsPageState();
}

class HttpLogsPageState extends BasePageWithProgress<HttpLogsPage> {
  final _pageController = PageController();

  var _currentLogs = HttpLogManager.instance.logValues();

  @override
  void initState() {
    super.initState();
    HttpLogManager.instance.updateHttpPage = getCurrentLogs;
    getCurrentLogs();
  }

  @override
  void dispose() {
    HttpLogManager.instance.updateHttpPage = null;
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget bodyWidget(BuildContext context) {
    return _currentLogs.isEmpty
        ? Center(
      child: Text(
        currentLogsMode == LogsMode.fromCurrentSession
            ? 'No request logs'
            : 'No request logs in previous sessions',
        style: CRStyle.bodyGreyMedium14,
      ),
    )
        : ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(
        bottom: 24,
        left: 16,
        right: 16,
      ),
      itemCount: _currentLogs.length,
      itemBuilder: (_, index) {
        final item = _currentLogs[index];

        return HttpItem(
          httpBean: item,
          onSelected: _onHttpBeanSelected,
          onRemove: _onRemoveLogPressed,
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
    );
  }

  @override
  Future<void> getCurrentLogs() async {
    switch (currentLogsMode) {
      case LogsMode.fromCurrentSession:
        _currentLogs = List
            .from(HttpLogManager.instance.logValues())
            .reversed
            .cast<HttpBean>()
            .toList();
        break;
      case LogsMode.fromDB:
        _currentLogs = HttpLogManager.instance.logsFromDB.reversed.toList();
        break;
    }
    _update();
  }

  Future<void> _onHttpBeanSelected(HttpBean httpBean) async {
    final onHttpBeanSelected = widget.onHttpBeanSelected;

    if (onHttpBeanSelected != null) {
      onHttpBeanSelected(httpBean);
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => HttpLogDetailsPage(httpBean),
        ),
      );
    }
  }

  Future<void> _onRemoveLogPressed(HttpBean httpBean) async {
    final okConfirmation = await showRemoveLogBottomSheet(
      context,
      message: httpBean.request?.url.path ?? '',
    );
    if (okConfirmation) {
      _removeLog(httpBean);
      showRemoveLogSnackBar(context, () => _insertLog(httpBean));
    }
  }

  void _removeLog(HttpBean httpBean) {
    HttpLogManager.instance.removeLog(httpBean);
    _currentLogs.removeWhere(
          (element) =>
      element.request?.id == httpBean.request?.id &&
          element.request?.id != null,
    );
  }

  Future<void> _insertLog(HttpBean httpBean) async {
    final logMng = HttpLogManager.instance;
    await logMng.saveHttpLog(httpBean);

    _currentLogs.insert(0, httpBean);

    switch (currentLogsMode) {
      case LogsMode.fromCurrentSession:
        final requestID = httpBean.request?.id;
        if (requestID != null) {
          logMng.keys.add(requestID.toString());
          logMng.logMap[requestID.toString()] = httpBean;
          logMng.logMap = logMng.sortLogsMapByTime(logMng.logMap);
        }
        break;
      case LogsMode.fromDB:
        logMng.logsFromDB.add(httpBean);
        logMng.logsFromDB =
            HttpLogManager.instance.sortLogsByTime(logMng.logsFromDB);
        break;
    }

    _update();
  }

  void _update() {
    if (mounted) {
      // ignore: no-empty-block
      setState(() {});
    }
  }
}
