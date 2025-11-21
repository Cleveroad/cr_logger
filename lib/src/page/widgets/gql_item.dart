import 'package:cr_logger/src/constants.dart';
import 'package:cr_logger/src/controllers/logs_mode_controller.dart';
import 'package:cr_logger/src/data/bean/gql_bean.dart';
import 'package:cr_logger/src/extensions/extensions.dart';
import 'package:cr_logger/src/extensions/graphql_ext.dart';
import 'package:cr_logger/src/extensions/string_ext.dart';
import 'package:cr_logger/src/models/request_status.dart';
import 'package:cr_logger/src/res/styles.dart';
import 'package:cr_logger/src/widget/copy_widget.dart';
import 'package:cr_logger/src/widget/remove_log_widget.dart';
import 'package:cr_logger/src/widget/rounded_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GQLItem extends StatelessWidget {
  const GQLItem({
    required this.httpBean,
    required this.onSelected,
    this.useWebLayout = false,
    this.onRemove,
    super.key,
  });

  final GQLBean httpBean;
  final bool useWebLayout;
  final ValueChanged<GQLBean> onSelected;
  final ValueChanged<GQLBean>? onRemove;

  @override
  Widget build(BuildContext context) {
    final status = httpBean.status;
    final method = GraphqlExt.fromString(httpBean.request?.operationType);
    final methodColor = method?.color;
    final statusCode =
        httpBean.response?.statusCode ?? httpBean.error?.statusCode;
    final operation = httpBean.request?.operationName ?? ' - ';

    final request = httpBean.request;

    /// [!kIsWeb] because the logs may be imported
    /// and then there is no way to know the date of the logs.
    final time = LogsModeController.instance.isFromCurrentSession && !kIsWeb
        ? request?.requestTime.formatTime(context)
        : request?.requestTime.formatTimeWithYear(context);

    final statusCodeText = statusCode != null
        ? status == RequestStatus.error
        ? 'Error'
        : statusCode.toString()
        : kSending;

    return RoundedCard(
      padding: const EdgeInsets.only(
        left: 16,
        top: 16,
        right: 16,
        bottom: 12,
      ),
      onTap: () => onSelected(httpBean),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [

              /// Request method
              SizedBox(
                child: Text(
                  method?.name.capitalize() ?? '',
                  style:
                  CRStyle.bodyBlackSemiBold14.copyWith(color: methodColor),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 12),

              /// Request status badge
              Container(
                height: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: status.color.withValues(alpha: 0.06),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 16,
                ),
                child: statusCode != null || status == RequestStatus.sending
                    ? FittedBox(
                  child: Text(
                    statusCodeText,
                    style: CRStyle.bodyBlackSemiBold14
                        .copyWith(color: status.color),
                    maxLines: 1,
                  ),
                )
                    : Icon(
                  status == RequestStatus.noInternet
                      ? Icons.wifi_off
                      : Icons.error,
                  color: status.color,
                  size: 14,
                ),
              ),
              const Expanded(child: SizedBox(width: 10)),

              /// Copy
              CopyWidget(
                onCopy: () => _onCopy(context),
              ),
            ],
          ),
          const SizedBox(height: 8),

          /// URL
          Text(
            operation,
            style: CRStyle.h3Black,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),

          /// Time and duration
          Row(
            children: [
              Expanded(
                child: Text(
                  '$time duration: ${httpBean.response?.duration ??
                      httpBean.error?.duration ?? 0}ms',
                  style: CRStyle.bodyGreyRegular14,
                ),
              ),
              RemoveLogWidget(onRemove: () => onRemove?.call(httpBean)),
            ],
          ),
        ],
      ),
    );
  }

  void _onCopy(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Copy \n"${httpBean.request?.url}"',
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
    Clipboard.setData(ClipboardData(text: httpBean.request?.url.path ?? ''));

    if (httpBean.request?.url != null) {
      Clipboard.setData(
        ClipboardData(
          text: httpBean.request?.url.path ?? '',
        ),
      );
    }
  }
}
