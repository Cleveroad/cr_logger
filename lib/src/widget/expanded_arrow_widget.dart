import 'dart:math' as math;

import 'package:cr_logger/generated/assets.dart';
import 'package:cr_logger/src/extensions/image_ext.dart';
import 'package:flutter/material.dart';

class ExpandedArrowWidget extends StatefulWidget {
  const ExpandedArrowWidget({
    required this.allExpandedNotifier,
    this.expanded = false,
    Key? key,
  }) : super(key: key);

  final bool expanded;
  final ValueNotifier<bool> allExpandedNotifier;

  @override
  State<ExpandedArrowWidget> createState() => _ExpandedArrowWidgetState();
}

class _ExpandedArrowWidgetState extends State<ExpandedArrowWidget> {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: widget.expanded ? math.pi : 0,
      child: IconButton(
        onPressed: () => widget.allExpandedNotifier.value = !widget.expanded,
        icon: ImageExt.fromPackage(
          Assets.assetsArrowDown,
          height: 28,
          width: 28,
        ),
        iconSize: 32,
        splashRadius: 20,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
