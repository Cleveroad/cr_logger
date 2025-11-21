import 'package:cr_logger/src/controllers/logs_mode.dart';
import 'package:cr_logger/src/controllers/logs_mode_controller.dart';
import 'package:cr_logger/src/cr_logger_helper.dart';
import 'package:cr_logger/src/page/search/http_search_page.dart';
import 'package:cr_logger/src/page/search/log_search_page.dart';
import 'package:cr_logger/src/res/colors.dart';
import 'package:cr_logger/src/res/styles.dart';
import 'package:cr_logger/src/widget/cr_back_button.dart';
import 'package:cr_logger/src/widget/options_buttons.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchCtrl = TextEditingController();

  final _pageController = PageController();

  final _logsMode = LogsModeController.instance.logMode.value;

  bool get _isCurrentLogMode => _logsMode == LogsMode.fromCurrentSession;

  @override
  void dispose() {
    _searchCtrl.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Theme(
        data: CRLoggerHelper.instance.theme,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: CRLoggerColors.backgroundGrey,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              backgroundColor: CRLoggerColors.backgroundGrey,

              /// App bar title
              title: Text(
                _isCurrentLogMode ? 'Search in logs' : 'Search log in DB',
                style: CRStyle.subtitle1BlackSemiBold17,
              ),
              leading: const CRBackButton(),

              /// Tabs: HTTP and Logs
              bottom: PreferredSize(
                preferredSize: const Size(
                  double.infinity,
                  kToolbarHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    left: 16,
                    right: 16,
                    bottom: 14,
                  ),
                  child: OptionsButtons(
                    titles: const ['HTTP', 'Logs'],
                    onSelected: _onChangedTab,
                  ),
                ),
              ),
            ),
            body: Column(
              children: [

                /// Correct page dependens on the tab. HTTP page or Logs page
                Expanded(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    children: const [
                      HttpSearchPage(),
                      LogSearchPage(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  void _onChangedTab(int index) {
    _pageController.jumpToPage(index);
  }
}
