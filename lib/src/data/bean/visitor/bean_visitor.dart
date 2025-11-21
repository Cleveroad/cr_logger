import 'package:cr_logger/src/data/bean/graphql/graphql_error_bean.dart';
import 'package:cr_logger/src/data/bean/graphql/graphql_request_bean.dart';
import 'package:cr_logger/src/data/bean/graphql/graphql_response_bean.dart';
import 'package:cr_logger/src/data/bean/http/http_error_bean.dart';
import 'package:cr_logger/src/data/bean/http/http_request_bean.dart';
import 'package:cr_logger/src/data/bean/http/http_response_bean.dart';

abstract class BeanVisitor {
  /// HTTP visitor
  void printHttpRequest(HttpRequestBean http);

  void printHttpResponse(HttpResponseBean http);

  void printHttpError(HttpErrorBean http);

  /// GraphQL visitor
  void printGraphQLRequest(GraphQLRequestBean graphql);

  void printGraphQLResponse(GraphQLResponseBean graphql);

  void printGraphQLError(GraphqlErrorBean graphql);
}
