import 'package:cr_json_widget/res/cr_json_color.dart';
import 'package:cr_logger/src/controllers/logs_mode_controller.dart';
import 'package:cr_logger/src/data/bean/log_bean.dart';
import 'package:cr_logger/src/data/models/log_type.dart';
import 'package:cr_logger/src/extensions/extensions.dart';
import 'package:cr_logger/src/res/styles.dart';
import 'package:cr_logger/src/widget/copy_widget.dart';
import 'package:cr_logger/src/widget/rounded_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocalLogItem extends StatelessWidget {
  LocalLogItem({
    required this.logType,
    required this.logBean,
    required this.onSelected,
    this.onLongTap,
    this.useWebLayout = false,
    super.key,
  });

  final LogType logType;
  final LogBean logBean;
  final bool useWebLayout;
  final ValueChanged<LogBean> onSelected;
  final ValueChanged<LogBean>? onLongTap;

  final _allExpandedNodesNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final stackTrace = logBean.stackTrace?.split('\n') ?? [];
    final isJsonData = logBean.message is Map<String, dynamic>;
    final logTap = onLongTap;

    /// [!kIsWeb] because the logs may be imported
    /// and then there is no way to know the date of the logs.
    final time = LogsModeController.instance.isFromCurrentSession && !kIsWeb
        ? logBean.time.formatTime()
        : logBean.time.formatTimeWithYear();

    return RoundedCard(
      padding: const EdgeInsets.only(
        left: 16,
        top: 16,
        right: 16,
        bottom: 12,
      ),
      onTap: () => onSelected(logBean),
      onLongTap: logTap != null ? () => logTap(logBean) : null,
      child: isJsonData
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder(
                  valueListenable: _allExpandedNodesNotifier,
                  builder: (
                    BuildContext context,
                    bool isAllNodesExpanded,
                    Widget? child,
                  ) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Json title
                        const Text(
                          'JSON object',
                          style: CRStyle.subtitle1BlackSemiBold16,
                        ),
                        const SizedBox(height: 10),

                        /// Json preview as a string
                        Text(
                          (logBean.message as Map<String, dynamic>).toString(),
                          style: const TextStyle(
                            color: CrJsonColors.objectColor,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 10),

                        /// Stacktrace
                        Text(
                          stackTrace.isNotEmpty ? stackTrace.first : '',
                          style: CRStyle.captionBlackRegular12,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),

                        /// Log time
                        Text(
                          'Time: $time',
                          style: CRStyle.bodyGreyRegular14,
                        ),
                      ],
                    );
                  },
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        logBean.message.toString(),
                        style: CRStyle.bodyGreyMedium14
                            .copyWith(color: logType.getColor()),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    CopyWidget(onCopy: () => _onCopy(context)),
                  ],
                ),
                const SizedBox(height: 10),

                /// Stacktrace
                Text(
                  stackTrace.isNotEmpty ? stackTrace.first : '',
                  style: CRStyle.captionBlackRegular12,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),

                /// Log time
                Text(
                  'Time: $time',
                  style: CRStyle.bodyGreyRegular14,
                ),
              ],
            ),
    );
  }

  void _onCopy(BuildContext context) {
    final logMessage = logBean.message.toString();

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Copy \n"$logMessage"',
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
    Clipboard.setData(ClipboardData(text: logMessage));
  }
}
