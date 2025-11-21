
import 'package:cr_logger/cr_logger.dart';
import 'package:ferry/ferry.dart';
import 'package:gql_http_link/gql_http_link.dart';

typedef GraphQLClient = Client;

Future<GraphQLClient> createGraphQLClient() async {
  //final url = 'https://dev.hasura.codexlabscorp.com/v1/graphql';
  const url = 'https://spacex-production.up.railway.app';

  final httpLink = HttpLink(url, defaultHeaders: {
    'content-type': 'application/json',
    'Test-Header': 'Test-Value',
  });
  final loggingLink = CRLoggerGQLLink(url);
  final client = Client(
    link: loggingLink.concat(httpLink),
  );
  log.d('GraphQL Client created with URL: ${httpLink.uri}');

  return client;
}
