import 'package:cr_logger/src/base/base_page_with_progress.dart';
import 'package:cr_logger/src/controllers/logs_mode.dart';
import 'package:cr_logger/src/data/bean/gql_bean.dart';
import 'package:cr_logger/src/managers/graphql_log_manager.dart';
import 'package:cr_logger/src/page/gql_logs/gql_log_details_page.dart';
import 'package:cr_logger/src/page/widgets/gql_item.dart';
import 'package:cr_logger/src/res/styles.dart';
import 'package:cr_logger/src/utils/show_remove_log_bottom_sheet.dart';
import 'package:cr_logger/src/utils/show_remove_log_snack_bar.dart';
import 'package:flutter/material.dart';

class GQLLogsPage extends StatefulWidget {
  const GQLLogsPage({
    this.onGqlBeanSelected,
    super.key,
  });

  final Function(GQLBean gqlBean)? onGqlBeanSelected;

  @override
  State<GQLLogsPage> createState() => GQLLogsPageState();
}

class GQLLogsPageState extends BasePageWithProgress<GQLLogsPage> {
  final _pageController = PageController();

  var _currentLogs = GraphQLLogManager.instance.logValues();

  @override
  void initState() {
    super.initState();
    GraphQLLogManager.instance.updateGQLPage = getCurrentLogs;
    getCurrentLogs();
  }

  @override
  void dispose() {
    GraphQLLogManager.instance.updateGQLPage = null;
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

        return GQLItem(
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
            .from(GraphQLLogManager.instance.logValues())
            .reversed
            .cast<GQLBean>()
            .toList();
        break;
      case LogsMode.fromDB:
        _currentLogs = GraphQLLogManager.instance.logsFromDB.reversed.toList();
        break;
    }
    _update();
  }

  Future<void> _onHttpBeanSelected(GQLBean gqlBean) async {
    final onHttpBeanSelected = widget.onGqlBeanSelected;

    if (onHttpBeanSelected != null) {
      onHttpBeanSelected(gqlBean);
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => GQLLogDetailsPage(gqlBean),
        ),
      );
    }
  }

  Future<void> _onRemoveLogPressed(GQLBean httpBean) async {
    final okConfirmation = await showRemoveLogBottomSheet(
      context,
      message: httpBean.request?.url.path ?? '',
    );
    if (okConfirmation) {
      _removeLog(httpBean);
      showRemoveLogSnackBar(context, () => _insertLog(httpBean));
    }
  }

  void _removeLog(GQLBean httpBean) {
    GraphQLLogManager.instance.removeLog(httpBean);
    _currentLogs.removeWhere(
          (element) =>
      element.request?.id == httpBean.request?.id &&
          element.request?.id != null,
    );
  }

  Future<void> _insertLog(GQLBean httpBean) async {
    final logMng = GraphQLLogManager.instance;
    await logMng.saveGQLBean(httpBean);

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
            GraphQLLogManager.instance.sortLogsByTime(logMng.logsFromDB);
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
