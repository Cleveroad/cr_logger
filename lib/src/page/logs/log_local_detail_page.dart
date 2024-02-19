import 'package:cr_logger/src/constants.dart';
import 'package:cr_logger/src/controllers/logs_mode_controller.dart';
import 'package:cr_logger/src/cr_logger_helper.dart';
import 'package:cr_logger/src/data/bean/log_bean.dart';
import 'package:cr_logger/src/data/models/log_type.dart';
import 'package:cr_logger/src/extensions/extensions.dart';
import 'package:cr_logger/src/page/widgets/json_details_widget.dart';
import 'package:cr_logger/src/res/colors.dart';
import 'package:cr_logger/src/res/styles.dart';
import 'package:cr_logger/src/utils/text_with_params_widget.dart';
import 'package:cr_logger/src/widget/copy_widget.dart';
import 'package:cr_logger/src/widget/cr_app_bar.dart';
import 'package:cr_logger/src/widget/rounded_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LogLocalDetailPage extends StatefulWidget {
  const LogLocalDetailPage({
    super.key,
    this.logBean,
    this.logType,
    this.scrollController,
    this.isWeb = false,
  });

  final bool isWeb;
  final LogBean? logBean;
  final LogType? logType;
  final ScrollController? scrollController;

  @override
  _LogLocalDetailPageState createState() => _LogLocalDetailPageState();
}

class _LogLocalDetailPageState extends State<LogLocalDetailPage> {
  final _listWidgetStackTrace = <Widget>[];

  @override
  void initState() {
    super.initState();
    getStackTraceListWidget();
  }

  @override
  Widget build(BuildContext context) {
    final logType = widget.logType ?? LogType.debug;
    final logName = logType.name;
    final log = widget.logBean;
    final logMessage = log?.message;
    final isJsonData = logMessage is Map<String, dynamic>;

    /// [!kIsWeb] because the logs may be imported
    /// and then there is no way to know the date of the logs.
    final time = LogsModeController.instance.isFromCurrentSession && !kIsWeb
        ? log?.time.formatTime(context)
        : log?.time.formatTimeWithYear(context);

    return Theme(
      data: CRLoggerHelper.instance.theme,
      child: Scaffold(
        appBar: widget.isWeb ? null : CRAppBar(title: '$logName log'),
        backgroundColor: CRLoggerColors.backgroundGrey,
        body: log == null
            ? const Text('No log bean')
            : SingleChildScrollView(
                controller: widget.scrollController,
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 8,
                  right: 16,
                  bottom: 16,
                ),
                child: RoundedCard(
                  padding: EdgeInsets.only(
                    left: 16,
                    top: isJsonData ? 10 : 16,
                    right: 16,
                    bottom: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Json data
                      if (isJsonData)
                        JsonDetailsWidget(logMessage: logMessage)
                      else

                        /// Log message with copy widget
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextWithParamsWidget(
                                logMessage,
                                textColor: log.color,
                                onParamTap: _onCopy,
                              ),
                            ),
                            const SizedBox(width: 10),
                            CopyWidget(
                              onCopy: () => _onCopy(logMessage.toString()),
                            ),
                          ],
                        ),
                      const SizedBox(height: 8),

                      /// Log time
                      Text(
                        'Time: $time',
                        style: CRStyle.bodyGreyRegular14,
                      ),
                      const SizedBox(height: 10),

                      /// Stacktrace
                      if (_listWidgetStackTrace.isNotEmpty)
                        ..._listWidgetStackTrace,
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  /// Needed for the web, since stacktrace is not updated
  @override
  void didUpdateWidget(covariant LogLocalDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    getStackTraceListWidget();
  }

  /// to highlight the stack trace
  Future<void> getStackTraceListWidget() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (_listWidgetStackTrace.isNotEmpty) {
      _listWidgetStackTrace.clear();
    }
    setState(() {
      if (widget.logBean?.stackTrace != null) {
        final listModelStackTrace = widget.logBean!.stackTrace!.split('\n');
        final packageName = packageInfo.packageName.split('.').last;

        for (final stackCall in listModelStackTrace) {
          if (stackCall.contains(packageName)) {
            final stackTraceParts = stackCall.split('package:');
            _listWidgetStackTrace.add(
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
            _listWidgetStackTrace.add(
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

  void _onCopy(String text) {
    final message = text.replaceAll(patternOfParamsRegex, '');

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Copy \n"$message"',
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
    Clipboard.setData(ClipboardData(text: message));
  }
}
