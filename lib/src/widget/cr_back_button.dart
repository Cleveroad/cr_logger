import 'package:cr_logger/generated/assets.dart';
import 'package:cr_logger/src/extensions/image_ext.dart';
import 'package:flutter/material.dart';

class CRBackButton extends StatelessWidget {
  const CRBackButton({
    Key? key,
    this.color,
    this.onPressed,
    this.showBackButton,
  }) : super(key: key);
  final bool? showBackButton;
  final Color? color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return (showBackButton == null
            ? Navigator.of(context).canPop()
            : (showBackButton ?? false))
        ? IconButton(
            icon: ImageExt.fromPackage(Assets.assetsIcBack),
            color: color,
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: () => _onBackPressed(context),
          )
        : const SizedBox();
  }

  void _onBackPressed(BuildContext context) {
    if (onPressed != null) {
      onPressed!();
    } else {
      Navigator.maybePop(context);
    }
  }
}
