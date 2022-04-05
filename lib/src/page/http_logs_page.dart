import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/extensions/do_post_frame.dart';
import 'package:cr_logger/src/page/http_log_details_page.dart';
import 'package:cr_logger/src/page/widgets/http_item.dart';
import 'package:cr_logger/src/styles.dart';
import 'package:flutter/material.dart';

class HttpLogsPage extends StatefulWidget {
  const HttpLogsPage({
    this.onHttpBeanSelected,
    this.scrollController,
    Key? key,
  }) : super(key: key);

  final Function(HttpBean httpBean)? onHttpBeanSelected;
  final ScrollController? scrollController;

  @override
  State<HttpLogsPage> createState() => HttpLogsPageState();
}

class HttpLogsPageState extends State<HttpLogsPage> {
  final _pageController = PageController();

  int currentIndex = 0;

  HttpBean? _selectedHttpBean;

  @override
  void initState() {
    super.initState();
    HttpLogManager.instance.onUpdate = _update;
  }

  @override
  void dispose() {
    HttpLogManager.instance.onUpdate = null;
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logMap = HttpLogManager.instance.logMap;
    final keys = HttpLogManager.instance.keys;
    if (logMap.isEmpty) {
      _selectedHttpBean = null;
    }

    return Column(
      children: [
        if (logMap.isEmpty)
          const Expanded(
            child: Center(
              child: Text(
                'No request log',
                style: CRStyle.bodyGreyMedium14,
              ),
            ),
          )
        else
          Expanded(
            child: ListView.separated(
              controller: widget.scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                bottom: 24,
                left: 16,
                right: 16,
              ),
              itemCount: keys.length,
              itemBuilder: (_, index) {
                final item = logMap[keys[index]];

                return (item != null)
                    ? HttpItem(
                        httpBean: item,
                        onSelected: _onHttpBeanSelected,
                      )
                    : const SizedBox.shrink();
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
            ),
          ),
      ],
    );
  }

  void _update() => doPostFrame(() {
        // ignore: no-empty-block
        setState(() {});
      });

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
}
