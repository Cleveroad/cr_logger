import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/base/base_page_with_progress.dart';
import 'package:cr_logger/src/controllers/logs_mode_controller.dart';
import 'package:cr_logger/src/page/http_logs/http_log_details_page.dart';
import 'package:cr_logger/src/page/widgets/http_item.dart';
import 'package:cr_logger/src/res/styles.dart';
import 'package:flutter/material.dart';

class HttpLogsPage extends StatefulWidget {
  const HttpLogsPage({
    this.onHttpBeanSelected,
    this.scrollController,
    super.key,
  });

  final Function(HttpBean httpBean)? onHttpBeanSelected;
  final ScrollController? scrollController;

  @override
  State<HttpLogsPage> createState() => HttpLogsPageState();
}

class HttpLogsPageState extends BasePageWithProgress<HttpLogsPage> {
  final _pageController = PageController();

  var _currentLogs = HttpLogManager.instance.logValues();

  HttpBean? _selectedHttpBean;

  @override
  void initState() {
    super.initState();
    HttpLogManager.instance.onUpdate = getCurrentLogs;
    HttpLogManager.instance.onUpdate?.call();
  }

  @override
  void dispose() {
    HttpLogManager.instance.onUpdate = null;
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget bodyWidget(BuildContext context) {
    if (_currentLogs.isEmpty) {
      _selectedHttpBean = null;
    }

    return _currentLogs.isEmpty
        ? const Center(
            child: Text(
              'No request log',
              style: CRStyle.bodyGreyMedium14,
            ),
          )
        : ListView.separated(
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

              return HttpItem(
                httpBean: item,
                onSelected: _onHttpBeanSelected,
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
          );
  }

  @override
  Future<void> getCurrentLogs() async {
    switch (currentLogsMode) {
      case LogsMode.fromCurrentSession:
        _currentLogs = List.from(HttpLogManager.instance.logValues())
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
    _selectedHttpBean = httpBean;

    if (widget.onHttpBeanSelected != null) {
      widget.onHttpBeanSelected?.call(_selectedHttpBean!);
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => HttpLogDetailsPage(httpBean),
        ),
      );
    }
  }

  void _update() {
    if (mounted) {
      // ignore: no-empty-block
      setState(() {});
    }
  }
}
