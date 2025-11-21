import 'package:cr_logger/generated/assets.dart';
import 'package:cr_logger/src/extensions/image_ext.dart';
import 'package:flutter/material.dart';

class CRBackButton extends StatelessWidget {
  const CRBackButton({
    super.key,
    this.color,
    this.onPressed,
    this.showBackButton,
  });

  final bool? showBackButton;
  final Color? color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return (showBackButton == null
        ? ModalRoute
        .of(context)
        ?.canPop == true
        : (showBackButton ?? false))
        ? IconButton(
      icon: ImageExt.fromPackage(CRLoggerAssets.assetsIcBack),
      color: color,
      tooltip: MaterialLocalizations
          .of(context)
          .backButtonTooltip,
      onPressed: () => _onBackPressed(context),
    )
        : const SizedBox();
  }

  void _onBackPressed(BuildContext context) {
    if (onPressed != null) {
      onPressed?.call();
    } else {
      Navigator.maybePop(context);
    }
  }
}
