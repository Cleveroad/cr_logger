import 'package:cr_logger/src/bean/log_bean.dart';
import 'package:cr_logger/src/bean/log_type.dart';
import 'package:cr_logger/src/colors.dart';
import 'package:cr_logger/src/cr_logger_helper.dart';
import 'package:cr_logger/src/extensions/extensions.dart';
import 'package:cr_logger/src/styles.dart';
import 'package:cr_logger/src/widget/copy_widget.dart';
import 'package:cr_logger/src/widget/cr_app_bar.dart';
import 'package:cr_logger/src/widget/expanded_arrow_widget.dart';
import 'package:cr_logger/src/widget/json_widget/json_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LogLocalDetailPage extends StatefulWidget {
  const LogLocalDetailPage({
    Key? key,
    this.logBean,
    this.logType,
    this.scrollController,
    this.isWeb = false,
  }) : super(key: key);

  final bool isWeb;
  final LogBean? logBean;
  final LogType? logType;
  final ScrollController? scrollController;

  @override
  _LogLocalDetailPageState createState() => _LogLocalDetailPageState();
}

class _LogLocalDetailPageState extends State<LogLocalDetailPage> {
  static const logTypes = {
    LogType.debug: 'Debug',
    LogType.info: 'Info',
    LogType.error: 'Error',
    LogType.http: 'HTTP',
  };

  final listWidgetStackTrace = <Widget>[];
  final _allExpandedNodesNotifier = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    getStackTraceListWidget();
  }

  @override
  Widget build(BuildContext context) {
    final logName = logTypes[widget.logType!];

    final isJsonData = widget.logBean?.message is Map<String, dynamic>;

    return Theme(
      data: CRLoggerHelper.instance.theme,
      child: Scaffold(
        appBar: widget.isWeb
            ? null
            : CRAppBar(
                title: '$logName log',
              ),
        backgroundColor: CRLoggerColors.backgroundGrey,
        body: widget.logBean == null
            ? const Text('No log bean')
            : SingleChildScrollView(
                controller: widget.scrollController,
                padding: const EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  16,
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: CRLoggerColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.fromLTRB(
                      16,
                      isJsonData ? 6 : 16,
                      16,
                      16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isJsonData) ...[
                          ValueListenableBuilder(
                            valueListenable: _allExpandedNodesNotifier,
                            builder: (
                              BuildContext context,
                              bool value,
                              Widget? child,
                            ) {
                              return Column(children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'JSON data',
                                      style: CRStyle.subtitle1BlackSemiBold16,
                                    ),
                                    ExpandedArrowWidget(
                                      expanded: value,
                                      allExpandedNotifier:
                                          _allExpandedNodesNotifier,
                                    ),
                                  ],
                                ),
                                JsonWidget(
                                  widget.logBean?.message
                                      as Map<String, dynamic>,
                                  allExpandedNodes: value,
                                ),
                              ]);
                            },
                          ),
                        ] else
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'message:\n${widget.logBean?.message}',
                                  style: CRStyle.bodyBlackMedium14.copyWith(
                                    color: widget.logBean?.color,
                                  ),
                                ),
                              ),
                              CopyWidget(onCopy: _onCopy),
                            ],
                          ),
                        const SizedBox(height: 8),
                        Text(
                          'time: ${widget.logBean?.time.formatTime()}',
                          style: CRStyle.bodyGreyRegular14,
                        ),
                        const SizedBox(height: 10),
                        if (listWidgetStackTrace.isNotEmpty)
                          ...listWidgetStackTrace,
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  /// to highlight the stack trace
  Future<void> getStackTraceListWidget() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      if (widget.logBean?.stackTrace != null) {
        final listModelStackTrace = widget.logBean!.stackTrace!.split('\n');
        final packageName = packageInfo.packageName.split('.').last;

        for (final stackCall in listModelStackTrace) {
          if (stackCall.contains(packageName)) {
            final stackTraceParts = stackCall.split('package:');
            listWidgetStackTrace.add(
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${stackTraceParts.first}package:',
                      style: CRStyle.captionBlackRegular12
                          .copyWith(color: CRLoggerColors.primaryColor),
                    ),
                    TextSpan(
                      text: stackTraceParts.last.split(')').first,
                      style: CRStyle.captionBlackSemiBold12
                          .copyWith(color: CRLoggerColors.linkColor),
                    ),
                    TextSpan(
                      text: ')',
                      style: CRStyle.captionBlackRegular12
                          .copyWith(color: CRLoggerColors.primaryColor),
                    ),
                  ],
                ),
              ),
            );
          } else {
            listWidgetStackTrace.add(
              Text(
                stackCall,
                style: CRStyle.h3Black,
              ),
            );
          }
        }
      }
    });
  }

  void _onCopy() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Copy \n"${widget.logBean?.message}"',
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
    Clipboard.setData(ClipboardData(text: widget.logBean?.message));
  }
}
