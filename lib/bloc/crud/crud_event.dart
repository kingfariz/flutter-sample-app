part of 'crud_bloc.dart';

@immutable
abstract class CrudEvent {}

class ReadData extends CrudEvent {
  final String page;
  ReadData({required this.page});
}
