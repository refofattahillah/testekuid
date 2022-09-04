import 'package:ekuid_project/model/model.dart';
import 'package:ekuid_project/modelview/Connection.dart';
import 'package:ekuid_project/modelview/Queries.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:myjobs/GraphQL/Connection.dart';
// import 'package:myjobs/GraphQL/Queries.dart';
// import 'package:myjobs/bloc/jobs_bloc.dart';
// import 'jobsModel.dart';

class Repository{
  GraphQLClient _client = clientToQuery();

  Future<List<Students>> fetchAllJobs() async{
    QueryResult result = await _client.query(
      QueryOptions(
        documentNode: gql(getAllStudentsQuery)
      )
    );

    if(!result.hasException)
    {
      print(result.data.toString());
      List data = result.data["persons"];
      List<Students> student =[];
      data.forEach((e){
        student.add(
          Students(
            id: e["id"],
            name: e["name"],
            lastName: e["lastName"],
            age: e["age"],
            )
        );
      });
      return student;
    }
  }

}
