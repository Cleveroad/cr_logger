import 'package:cr_logger/src/colors.dart';
import 'package:cr_logger/src/constants.dart';
import 'package:cr_logger/src/styles.dart';
import 'package:cr_logger/src/widget/cr_back_button.dart';
import 'package:flutter/material.dart';

class CRAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CRAppBar({
    this.title = '',
    this.onBackTap,
    this.showBackButton,
    this.backButtonColor,
    this.onBackPressed,
    this.actions,
    this.reverse = false,
    this.showLoggerVersion = false,
    this.centerTitle = true,
    Key? key,
  }) : super(key: key);

  final String title;
  final bool centerTitle;
  final bool reverse;
  final bool showLoggerVersion;
  final VoidCallback? onBackTap;
  final bool? showBackButton;
  final Color? backButtonColor;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
        centerTitle: centerTitle,
        automaticallyImplyLeading: false,
        leading: CRBackButton(
          color: backButtonColor,
          showBackButton: showBackButton,
          onPressed: onBackPressed,
        ),
        title: showLoggerVersion
            ? const Text(
                'cr_logger $kVersion',
                style: CRStyle.bodyGreyMedium14,
              )
            : Text(
                title,
                style: CRStyle.subtitle1BlackSemiBold17,
              ),
        elevation: 0,
        backgroundColor: CRLoggerColors.backgroundGrey,
        actions: actions,
      );
}
