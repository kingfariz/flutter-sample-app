part of 'crud_bloc.dart';

@immutable
abstract class CrudState {}

class CrudLoading extends CrudState {}

class CrudError extends CrudState {}

class ReadDataSuccess extends CrudState {
  final List<dynamic> data;
  ReadDataSuccess(this.data);
  List<Object?> get props => [data];
}

class SendDataSucces extends CrudState {}
