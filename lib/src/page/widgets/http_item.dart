import 'package:cr_logger/src/constants.dart';
import 'package:cr_logger/src/controllers/logs_mode_controller.dart';
import 'package:cr_logger/src/data/bean/http_bean.dart';
import 'package:cr_logger/src/extensions/extensions.dart';
import 'package:cr_logger/src/models/request_status.dart';
import 'package:cr_logger/src/res/colors.dart';
import 'package:cr_logger/src/res/styles.dart';
import 'package:cr_logger/src/utils/parsers/url_parser.dart';
import 'package:cr_logger/src/widget/copy_widget.dart';
import 'package:cr_logger/src/widget/rounded_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HttpItem extends StatelessWidget {
  const HttpItem({
    required this.httpBean,
    required this.onSelected,
    this.useWebLayout = false,
    super.key,
  });

  final HttpBean httpBean;
  final bool useWebLayout;
  final ValueChanged<HttpBean> onSelected;

  @override
  Widget build(BuildContext context) {
    final status = httpBean.status;
    final methodColor = httpBean.request?.method == kMethodPost
        ? CRLoggerColors.orange
        : CRLoggerColors.green;
    final statusCode =
        httpBean.response?.statusCode ?? httpBean.error?.statusCode;
    final urlWithHiddenParams =
        getUrlWithHiddenParams(httpBean.request?.url ?? '');

    final request = httpBean.request;

    /// [!kIsWeb] because the logs may be imported
    /// and then there is no way to know the date of the logs.
    final time = LogsModeController.instance.isFromCurrentSession && !kIsWeb
        ? request?.requestTime?.formatTime()
        : request?.requestTime?.formatTimeWithYear();

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
                  request?.method ?? '',
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
                  color: status.color.withOpacity(0.06),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 16,
                ),
                child: statusCode != null || status == RequestStatus.sending
                    ? FittedBox(
                        child: Text(
                          statusCode != null ? statusCode.toString() : kSending,
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
            urlWithHiddenParams,
            style: CRStyle.h3Black,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),

          /// Time and duration
          Text(
            '$time duration: ${httpBean.response?.duration ?? httpBean.error?.duration ?? 0}ms',
            style: CRStyle.bodyGreyRegular14,
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

    if (httpBean.request?.url != null) {
      Clipboard.setData(
        ClipboardData(
          text: httpBean.request!.url ?? '',
        ),
      );
    }
  }
}
