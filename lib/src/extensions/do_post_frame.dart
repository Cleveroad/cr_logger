import 'package:flutter/material.dart';

extension StateExt on State {
  void doPostFrame(Function func) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      func();
    });
  }
}
