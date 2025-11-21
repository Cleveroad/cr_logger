import 'package:cr_json_widget/res/cr_json_color.dart';
import 'package:cr_logger/src/constants.dart';
import 'package:cr_logger/src/controllers/logs_mode_controller.dart';
import 'package:cr_logger/src/data/bean/log_bean.dart';
import 'package:cr_logger/src/data/models/log_type.dart';
import 'package:cr_logger/src/extensions/extensions.dart';
import 'package:cr_logger/src/res/styles.dart';
import 'package:cr_logger/src/widget/copy_widget.dart';
import 'package:cr_logger/src/widget/remove_log_widget.dart';
import 'package:cr_logger/src/widget/rounded_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocalLogItem extends StatelessWidget {
  const LocalLogItem({
    required this.logType,
    required this.logBean,
    required this.onSelected,
    this.onRemove,
    this.onLongTap,
    this.useWebLayout = false,
    super.key,
  });

  final LogType logType;
  final LogBean logBean;
  final bool useWebLayout;
  final ValueChanged<LogBean> onSelected;
  final ValueChanged<LogBean>? onRemove;
  final ValueChanged<LogBean>? onLongTap;

  @override
  Widget build(BuildContext context) {
    final logMessage = logBean.message;

    final isJsonData = logMessage is Map<String, dynamic>;
    final logTap = onLongTap;

    /// [!kIsWeb] because the logs may be imported
    /// and then there is no way to know the date of the logs.
    final time = LogsModeController.instance.isFromCurrentSession && !kIsWeb
        ? logBean.time.formatTime(context)
        : logBean.time.formatTimeWithYear(context);

    return RoundedCard(
      padding: const EdgeInsets.only(
        left: 16,
        top: 16,
        right: 16,
        bottom: 12,
      ),
      onTap: () => onSelected(logBean),
      onLongTap: logTap != null ? () => logTap(logBean) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isJsonData) ...[

            /// Json title
            const Text(
              'JSON object',
              style: CRStyle.subtitle1BlackSemiBold16,
            ),
            const SizedBox(height: 10),

            /// Json preview as a string
            Text(
              logMessage.toString(),
              style: const TextStyle(
                color: CrJsonColors.objectColor,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ] else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                /// Title
                Expanded(
                  child: Text(
                    logMessage.toString().replaceAll(patternOfParamsRegex, ''),
                    style:
                    CRStyle.bodyGreyMedium14.copyWith(color: logBean.color),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),

                /// Copy button
                CopyWidget(onCopy: () => _onCopy(context)),
              ],
            ),
          const SizedBox(height: 10),
          Row(
            children: [

              /// Log time
              Expanded(
                child: Text(
                  'Time: $time',
                  style: CRStyle.bodyGreyRegular14,
                ),
              ),

              /// Remove button
              RemoveLogWidget(onRemove: () => onRemove?.call(logBean)),
            ],
          ),
        ],
      ),
    );
  }

  void _onCopy(BuildContext context) {
    final logMessage =
    logBean.message.toString().replaceAll(patternOfParamsRegex, '');

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
