import 'dart:async';
import 'dart:math';

import 'package:cr_logger/src/cr_logger_helper.dart';
import 'package:cr_logger/src/page/widgets/popup_menu.dart';
import 'package:cr_logger/src/res/colors.dart';
import 'package:cr_logger/src/res/theme.dart';
import 'package:cr_logger/src/widget/build_number.dart';
import 'package:flutter/material.dart';

/// Key to access the pop-up menu widget
final popupButtonKey = GlobalKey<PopupMenuButtonState>();

class DraggableButtonWidget extends StatefulWidget {
  const DraggableButtonWidget({
    required this.leftPos,
    required this.topPos,
    required this.onLoggerOpen,
    this.title = 'log',
    this.btnSize = 48,
    super.key,
  });

  final double leftPos;
  final double topPos;
  final String title;
  final double btnSize;
  final Function(BuildContext context) onLoggerOpen;

  @override
  _DraggableButtonWidgetState createState() => _DraggableButtonWidgetState();
}

class _DraggableButtonWidgetState extends State<DraggableButtonWidget> {
  static const spaceForBuildNumberText = 36.0;
  late double left = widget.leftPos;
  late double top = widget.topPos;
  double screenWidth = 0;
  double screenHeight = 0;

  bool isShow = true;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    /// Round

    /// Calculating offset limits

    left = max(left, 1);
    left = min(screenWidth - widget.btnSize, left);

    top = max(top, 1);
    top = min(top, screenHeight - widget.btnSize);

    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: left, top: top),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.btnSize / 2),
        child: Opacity(
          opacity: isShow ? 0.7 : 0,
          child: IgnorePointer(
            ignoring: !isShow,
            child: Material(
              child: Theme(
                data: loggerTheme,
                child: PopupMenu(
                  popupKey: popupButtonKey,
                  onCanceled: _onCanceledPopup,
                  child: GestureDetector(
                    onTap: () => _defaultClick(context),
                    onLongPress: _onPressDraggableButton,
                    onDoubleTap: _onPressDraggableButton,
                    onPanUpdate: _dragUpdate,
                    child: Container(
                      width: widget.btnSize + spaceForBuildNumberText,
                      height: widget.btnSize,
                      color: CRLoggerColors.primaryColor,
                      child: Center(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 2,
                          children: [
                            ValueListenableBuilder(
                              valueListenable:
                                  CRLoggerHelper.instance.loggerShowingNotifier,
                              //ignore:prefer-trailing-comma
                              builder: (context, loggerShowing, child) {
                                return Icon(
                                  loggerShowing
                                      ? Icons.visibility_off
                                      : Icons.bug_report,
                                  color: Colors.white,
                                );
                              },
                            ),
                            const BuildNumber(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _defaultClick(BuildContext context) async {
    setState(() {
      if (CRLoggerHelper.instance.isLoggerShowing) {
        CRLoggerHelper.instance.hideLogger();
      } else {
        widget.onLoggerOpen(context);
        CRLoggerHelper.instance.showLogger();
      }
    });
  }

  void _onPressDraggableButton() {
    if (!CRLoggerHelper.instance.isLoggerShowing) {
      setState(() {
        isShow = false;
      });
      popupButtonKey.currentState?.showButtonMenu();
    }
  }

  void _onCanceledPopup() {
    setState(() {
      isShow = true;
    });
  }

  void _dragUpdate(DragUpdateDetails detail) {
    setState(() {
      final offset = detail.delta;
      left = left + offset.dx;
      top = top + offset.dy;
    });
  }
}
