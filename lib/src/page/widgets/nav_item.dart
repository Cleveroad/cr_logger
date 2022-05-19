import 'package:cr_logger/src/styles.dart';
import 'package:flutter/material.dart';

class NavItem extends StatelessWidget {
  const NavItem({
    required this.title,
    required this.onTap,
    this.enabled = false,
    super.key,
  });

  final String title;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTap,
            child: Text(
              title,
              style: CRStyle.h1Black
                  .copyWith(color: enabled ? Colors.black : Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}
