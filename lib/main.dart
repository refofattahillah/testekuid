import 'package:ekuid_project/bloc/student_bloc.dart';
import 'package:ekuid_project/modelview/Connection.dart';
import 'package:ekuid_project/modelview/Queries.dart';
import 'package:ekuid_project/modelview/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_restart/flutter_restart.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Repository repository = new Repository();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<StudentBloc>(
            create: (context) =>
                StudentBloc(repository: repository)..add(AppStarted()),
          )
        ],
        child: MaterialApp(
            title: 'Case Solving Ekuid GraphQL',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: BlocBuilder<StudentBloc, StudentsState>(
              builder: (context, state) {
                return Home();
              },
            )));
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final formKey = GlobalKey<FormState>();
  String newid;
  String newfname;
  String newlname;
  int newage;
  String editid;
  String editname;
  String editlname;
  int editage;

  showAlertDialog(BuildContext context) {

  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () { Navigator.of(context).pop();},
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Notification"),
    content: Text("Please Fill the Form"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

  String validateID(String value) {
    if (value == null || value.isEmpty || value == ' ')
      return 'ID Cant be Empty';
    else
      return null;
  }

  String validateName(String value) {
    if (value == null || value.isEmpty || value == ' ')
      return 'First Name Cant be Empty';
    else
      return null;
  }

  String validateLName(String value) {
    if (value == null || value.isEmpty || value == ' ')
      return 'Last Name Cant be Empty';
    else
      return null;
  }

  String validateage(String value) {
    if (value == null || value.isEmpty || value == ' ' || value == '0')
      return 'Age Cant be Empty / Must be Greater than 0';
    else
      return null;
  }

  showeditDialog(String id, String fname, String lname, int age){
    showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: Text('Edit Data Siswa'),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            enabled: false,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            enableInteractiveSelection: false,
                            validator: (value) => validateID(value),
                            onChanged: (text) {
                              editid = text;
                            },
                            decoration: InputDecoration(
                              labelText: id,
                              icon: Icon(Icons.format_list_numbered),
                            ),
                          ),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            enableInteractiveSelection: false,
                            validator: (value) => validateName(value),
                            onChanged: (text) {
                              editname = text;
                            },
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              labelText: fname,
                              icon: Icon(Icons.account_box),
                            ),
                          ),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            enableInteractiveSelection: false,
                            validator: (value) => validateLName(value),
                            onChanged: (text) {
                              editlname = text;
                            },
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              labelText: lname,
                              icon: Icon(Icons.account_box_outlined),
                            ),
                          ),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            enableInteractiveSelection: false,
                            validator: (value) => validateLName(value),
                            onChanged: (text) {
                              editage = int.parse(text);
                            },
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              labelText: age.toString(),
                              icon: Icon(Icons.calendar_today),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    RaisedButton(
                        color: Colors.blue,
                        child: Text("Submit"),
                        onPressed: () async {
                          if (editname != null &&
                              editlname != null &&
                              editage != null) {
                            final variable = {
                              "id": id,
                              "name": editname,
                              "lastName": editlname,
                              "age": editage
                            };

                            QueryResult queryResult =
                                await clientToQuery().query(
                              QueryOptions(
                                  documentNode: gql(updatedata),
                                  variables: variable),
                            );
                            FlutterRestart.restartApp();
                            return queryResult;
                          } else {
                            showAlertDialog(context);
                          }
                        })
                  ],
                );
              });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: Text('Input Data Siswa Baru'),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            enableInteractiveSelection: false,
                            validator: (value) => validateID(value),
                            onChanged: (text) {
                              newid = text;
                            },
                            decoration: InputDecoration(
                              labelText: 'ID',
                              icon: Icon(Icons.format_list_numbered),
                            ),
                          ),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            enableInteractiveSelection: false,
                            validator: (value) => validateName(value),
                            onChanged: (text) {
                              newfname = text;
                            },
                            decoration: InputDecoration(
                              labelText: 'Name',
                              icon: Icon(Icons.account_box),
                            ),
                          ),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            enableInteractiveSelection: false,
                            validator: (value) => validateLName(value),
                            onChanged: (text) {
                              newlname = text;
                            },
                            decoration: InputDecoration(
                              labelText: 'Last Name',
                              icon: Icon(Icons.account_box_outlined),
                            ),
                          ),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            enableInteractiveSelection: false,
                            validator: (value) => validateLName(value),
                            onChanged: (text) {
                              newage = int.parse(text);
                            },
                            decoration: InputDecoration(
                              labelText: 'Age',
                              icon: Icon(Icons.calendar_today),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    RaisedButton(
                        color: Colors.blue,
                        child: Text("Submit"),
                        onPressed: () async {
                          if (newid != null &&
                              newfname != null &&
                              newlname != null &&
                              newage != null) {
                            final variable = {
                              "id": newid,
                              "name": newfname,
                              "lastName": newlname,
                              "age": newage
                            };

                            QueryResult queryResult =
                                await clientToQuery().query(
                              QueryOptions(
                                  documentNode: gql(insertdata),
                                  variables: variable),
                            );
                            FlutterRestart.restartApp();
                            return queryResult;
                          } else {
                            showAlertDialog(context);
                          }
                        })
                  ],
                );
              });
        },
        icon: Icon(Icons.add),
        label: Text("Tambah Siswa"),
      ),
      appBar: AppBar(
        title: Text("Case Solving Ekuid GraphQL"),
      ),
      body: BlocBuilder<StudentBloc, StudentsState>(
        builder: (context, state) {
          if (state is Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is LoadStudent) {
            return ListView.separated(
                separatorBuilder: (context, index) => Divider(
                      color: Colors.green,
                      thickness: 2,
                    ),
                itemCount: state.student.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.width * 0.3,
                        child: Row(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                color: Color(0xffDBFFCB),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8.0),
                                      bottomLeft: Radius.circular(8.0)),
                                  child: Icon(Icons.people),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Nama Siswa : ' +
                                              state.student[index].name,
                                          // overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            showeditDialog(state.student[index].id, state.student[index].name, state.student[index].lastName, state.student[index].age);
                                          },
                                          child: Icon(Icons.edit_rounded))
                                      ],
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 2, 10, 2),
                                            child: Text('ID Siswa : ' +
                                                state.student[index].id),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(40)),
                                              color: Colors.yellow.shade200,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 2, 10, 2),
                                            child: Text(
                                              'Umur : ' +
                                                  state.student[index].age
                                                      .toString(),
                                              style: TextStyle(
                                                color: Colors.grey.shade900,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(40)),
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                });
          }
        },
      ),
    );
  }
}
