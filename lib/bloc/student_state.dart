part of 'student_bloc.dart';

@immutable
abstract class StudentsState {}

class StudentInitial extends StudentsState {}


class Loading extends StudentsState {}

class LoadStudent extends StudentsState{
  List<Students> student;
  LoadStudent({this.student});
}