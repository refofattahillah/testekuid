import 'package:graphql_flutter/graphql_flutter.dart';
final HttpLink httpLink = HttpLink(
  uri: "https://examplegraphql.herokuapp.com/graphql/",
);

GraphQLClient clientToQuery() {
  return GraphQLClient(
    // cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
    cache: InMemoryCache(),
    link: httpLink,
  );
}