import 'package:cr_logger/src/widget/adaptive_layout/layout_types.dart';
import 'package:flutter/material.dart';

export 'layout_types.dart';

typedef LayoutTypeChanged = void Function(LayoutType layoutType);

class LayoutTypeProvider extends InheritedWidget {
  const LayoutTypeProvider({
    required this.layoutType,
    required Widget child,
    Key? key,
  }) : super(child: child, key: key);

  final LayoutType layoutType;

  static LayoutTypeProvider of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<LayoutTypeProvider>();
    assert(result != null, 'No LayoutType found in context');

    return result!;
  }

  @override
  bool updateShouldNotify(covariant LayoutTypeProvider oldWidget) {
    return layoutType != oldWidget.layoutType;
  }
}
