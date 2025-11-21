import 'package:cr_logger/src/cr_logger_helper.dart';
import 'package:cr_logger/src/data/bean/gql_bean.dart';
import 'package:cr_logger/src/dio_log.dart';
import 'package:cr_logger/src/models/http_log_type.dart';
import 'package:cr_logger/src/res/colors.dart';
import 'package:cr_logger/src/widget/cr_app_bar.dart';
import 'package:cr_logger/src/widget/gql_error_widget.dart';
import 'package:cr_logger/src/widget/gql_request_widget.dart';
import 'package:cr_logger/src/widget/gql_response_widget.dart';
import 'package:cr_logger/src/widget/options_buttons.dart';
import 'package:flutter/material.dart';

class GQLLogDetailsPage extends StatefulWidget {
  const GQLLogDetailsPage(this.netOptions, {
    this.isWeb = false,
    super.key,
  });

  final GQLBean netOptions;
  final bool isWeb;

  @override
  _GQLLogDetailsPageState createState() => _GQLLogDetailsPageState();
}

class _GQLLogDetailsPageState extends State<GQLLogDetailsPage>
    with SingleTickerProviderStateMixin {
  final _pageController = PageController();
  final _navKey = GlobalKey<OptionsButtonsState>();

  int currentIndex = 0;

  /// Global keys for all expanded nodes
  final _requestPageGlobalKey = GlobalKey<HttpRequestWidgetState>();
  final _responsePageGlobalKey = GlobalKey<HttpResponseWidgetState>();

  HttpLogType _currentLogType = HttpLogType.request;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: CRLoggerHelper.instance.theme,
      child: Scaffold(
        backgroundColor: CRLoggerColors.backgroundGrey,
        appBar: widget.isWeb ? null : const CRAppBar(title: 'Http log'),
        body: Column(
          children: [
            Container(
              color: CRLoggerColors.backgroundGrey,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OptionsButtons(
                key: _navKey,
                titles: [
                  HttpLogType.request.asString(),
                  HttpLogType.response.asString(),
                  HttpLogType.error.asString(),
                ],
                onSelected: _onPageSelected,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: PageView(
                controller: _pageController,
                children: [
                  GQLRequestWidget(
                    widget.netOptions,
                    key: _requestPageGlobalKey,
                  ),
                  // const SizedBox(),
                  GQLResponseWidget(
                    widget.netOptions,
                    key: _responsePageGlobalKey,
                  ),
                  GQLErrorWidget(widget.netOptions),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPageChanged() {
    _currentLogType = HttpLogType.values[_pageController.page?.round() ?? 0];
    _navKey.currentState?.change(_currentLogType.index);
  }

  void _onPageSelected(int index) {
    _currentLogType = HttpLogType.values[index];
    _pageController.jumpToPage(index);
  }
}
