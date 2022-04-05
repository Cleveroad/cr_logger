import 'package:cr_logger/src/utils/web_utils.dart';
import 'package:cr_logger/src/widget/adaptive_layout/layout_type_inherited.dart';
import 'package:flutter/material.dart';

class AdaptiveLayoutWidget extends StatefulWidget {
  const AdaptiveLayoutWidget({
    required this.mobileLayoutWidget,
    required this.webLayoutWidget,
    this.onLayoutChange,
    Key? key,
  }) : super(key: key);

  final Widget mobileLayoutWidget;
  final Widget webLayoutWidget;
  final LayoutTypeChanged? onLayoutChange;

  @override
  _AdaptiveLayoutWidgetState createState() => _AdaptiveLayoutWidgetState();
}

class _AdaptiveLayoutWidgetState extends State<AdaptiveLayoutWidget> {
  LayoutType _layoutType = LayoutType.web;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final layoutType = _getLayoutTypeFromConstraints(constraints);

        // Use callback only when layout changed.
        if (_layoutType != layoutType) {
          _layoutType = layoutType;
          widget.onLayoutChange?.call(_layoutType);
        }

        return LayoutTypeProvider(
          layoutType: _layoutType,
          child: _layoutType.isWebLayout
              ? widget.webLayoutWidget
              : widget.mobileLayoutWidget,
        );
      },
    );
  }

  LayoutType _getLayoutTypeFromConstraints(BoxConstraints constraints) {
    return constraints.maxWidth > kWidthTrashHoldForMobileLayout
        ? LayoutType.web
        : LayoutType.mobile;
  }
}
