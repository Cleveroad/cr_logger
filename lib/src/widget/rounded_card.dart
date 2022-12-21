import 'package:cr_logger/src/res/colors.dart';
import 'package:flutter/material.dart';

class RoundedCard extends StatelessWidget {
  const RoundedCard({
    required this.child,
    this.onTap,
    this.onLongTap,
    this.padding,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongTap,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          decoration: BoxDecoration(
            color: CRLoggerColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: padding ??
              const EdgeInsets.only(
                left: 16,
                top: 10,
                right: 16,
                bottom: 10,
              ),
          child: child,
        ),
      ),
    );
  }
}
