import 'package:cr_logger/src/data/bean/base/bean_factory.dart';
import 'package:cr_logger/src/data/bean/visitor/i_bean_visitor.dart';

abstract class BaseBean implements IBeanVisitor {
  BaseBean({
    required this.id,
    required this.url,
    this.duration,
    this.headers,
  });

  final int id;
  final Uri url;
  int? duration;
  Map<String, dynamic>? headers;

  String get type => runtimeType.toString();

  Map<String, dynamic> toJson();

  static BaseBean fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;

    return BeanFactory.createFromJson(type, json);
  }
}
