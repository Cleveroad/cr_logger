import 'package:cr_logger/src/data/bean/graphql/graphql_error_bean.dart';
import 'package:cr_logger/src/data/bean/graphql/graphql_request_bean.dart';
import 'package:cr_logger/src/data/bean/graphql/graphql_response_bean.dart';
import 'package:cr_logger/src/managers/graphql_log_manager.dart';
import 'package:gql_exec/gql_exec.dart';
import 'package:gql_link/gql_link.dart';
import 'package:uuid/uuid.dart';

class CRLoggerGQLLink extends Link {
  CRLoggerGQLLink(final String url) : _url = url;

  final _manager = GraphQLLogManager.instance;
  final String _url;

  @override
  Stream<Response> request(Request request, [NextLink? forward]) {
    if (forward == null) {
      throw StateError('Forward link is null');
    }

    final headers = request.context.entry<HttpLinkHeaders>();
    final url = Uri.parse(_url);
    final id = const Uuid()
        .v4()
        .hashCode;

    final requestBean = GraphQLRequestBean(
      id: id,
      url: url,
      // operation: request.operation,
      requestTime: DateTime.now(),
      variables: request.variables,
      headers: headers?.headers,
      operationName: request.operation.operationName,
      operationType: request.operation
          .getOperationType()
          ?.name,
    );

    _manager.onRequest(requestBean);
    final stream = forward(request);

    return stream.map((result) {
      final context = result.context.entry<HttpLinkResponseContext>();
      final response = result.response;
      final errors = result.errors;
      if (errors != null && errors.isNotEmpty) {
        final errorBean = GraphqlErrorBean(
          id: id,
          url: url,
          errorTime: DateTime.now(),
          errorData: errors,
          statusCode: context?.statusCode,
          gqlErrors: errors,
          headers: context?.headers,
          operationName: request.operation.operationName,
        );

        _manager.onError(errorBean);
      }

      if (response.isNotEmpty) {
        final responseBean = GraphQLResponseBean(
          id: id,
          url: url,
          headers: context?.headers,
          statusCode: context?.statusCode,
          responseTime: DateTime.now(),
          data: response,
          operationName: request.operation.operationName,
        );

        _manager.onResponse(responseBean);
      }

      return result;
    }).handleError((error, stacktrace) {
      // final errorBean = GraphqlErrorBean(
      //   id: request.hashCode,
      //   url: Uri.parse('https://s.ss'),
      //   errorTime: DateTime.now(),
      //   errorData: errorData,
      // );
    });
  }
}
