import 'package:flutter/material.dart';
import 'package:gql/ast.dart';

extension GraphqlExt on OperationType {
  static OperationType? fromString(String? type) =>
      {
        'query': OperationType.query,
        'mutation': OperationType.mutation,
        'subscription': OperationType.subscription,
      }[type];

  Color get color {
    switch (this) {
      case OperationType.query:
        return Colors.deepOrange; // Green
      case OperationType.mutation:
        return Colors.purple; // Red
      case OperationType.subscription:
        return const Color(0xFF0000FF); // Blue
    }
  }
}
