import 'package:cr_logger/src/data/bean/visitor/bean_visitor.dart';

// ignore: one_member_abstracts
abstract interface class IBeanVisitor {
  void apply(BeanVisitor visitor);
}
