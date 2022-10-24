import 'package:cr_logger/src/colors.dart';
import 'package:flutter/material.dart';

enum RequestStatus {
  sending(CRLoggerColors.yellow),
  success(CRLoggerColors.green),
  error(CRLoggerColors.red),
  noInternet(CRLoggerColors.red);

  const RequestStatus(this.color);

  final Color color;
}
