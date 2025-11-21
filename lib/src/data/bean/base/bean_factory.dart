import 'package:cr_logger/src/data/bean/base/base_bean.dart';
import 'package:cr_logger/src/data/bean/graphql/graphql_error_bean.dart';
import 'package:cr_logger/src/data/bean/graphql/graphql_request_bean.dart';
import 'package:cr_logger/src/data/bean/graphql/graphql_response_bean.dart';
import 'package:cr_logger/src/data/bean/http/http_error_bean.dart';
import 'package:cr_logger/src/data/bean/http/http_request_bean.dart';
import 'package:cr_logger/src/data/bean/http/http_response_bean.dart';

// ignore: avoid_classes_with_only_static_members
final class BeanFactory {
  static BaseBean createFromJson(String type, Map<String, dynamic> json) {
    switch (type) {
      case 'HttpRequestBean':
        return HttpRequestBean.fromJson(json);
      case 'HttpResponseBean':
        return HttpResponseBean.fromJson(json);
      case 'HttpErrorBean':
        return HttpErrorBean.fromJson(json);
      case 'GraphQLRequestBean':
        return GraphQLRequestBean.fromJson(json);
      case 'GraphQLResponseBean':
        return GraphQLResponseBean.fromJson(json);
      case 'GraphqlErrorBean':
        return GraphqlErrorBean.fromJson(json);
      default:
        throw ArgumentError('Unknown bean type: $type');
    }
  }
}
