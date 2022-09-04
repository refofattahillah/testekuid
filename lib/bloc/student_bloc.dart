import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ekuid_project/model/model.dart';
import 'package:ekuid_project/modelview/repository.dart';
import 'package:meta/meta.dart';
part 'student_event.dart';
part 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentsState> {
  Repository repository;
  StudentBloc({this.repository});
  @override
  StudentsState get initialState => StudentInitial();

  @override
  Stream<StudentsState> mapEventToState(
    StudentEvent event,
  ) async* {
  
    if(event is AppStarted)
    {
      yield Loading();
      var student = await repository.fetchAllJobs();
      yield LoadStudent(student:student);
    }
  
  }
}