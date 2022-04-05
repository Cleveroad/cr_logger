import 'package:cr_logger/src/constants.dart';
import 'package:cr_logger/src/page/widgets/popup_menu.dart';
import 'package:cr_logger/src/styles.dart';
import 'package:flutter/material.dart';

class CRWebAppBar extends StatelessWidget {
  const CRWebAppBar({
    required this.popupKey,
    Key? key,
  }) : super(key: key);

  final GlobalKey popupKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PopupMenu(
            popupKey: popupKey,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: const [
                  Icon(Icons.view_headline),
                  SizedBox(width: 10),
                  Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Text(
                      'Menu',
                      style: CRStyle.subtitle1BlackSemiBold16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Text(
            'cr_logger $kVersion',
            style: CRStyle.bodyGreyMedium14,
          ),
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: const [
                  Text(
                    'Close',
                    style: CRStyle.subtitle1BlackSemiBold16,
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.close),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
