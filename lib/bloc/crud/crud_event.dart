part of 'crud_bloc.dart';

@immutable
abstract class CrudEvent {}

class ReadData extends CrudEvent {
  final String page;
  ReadData({required this.page});
}

class SendData extends CrudEvent {
  final Map<String, dynamic> postData;
  SendData({required this.postData});
}

class UpdateData extends CrudEvent {
  final Map<String, dynamic> postData;
  UpdateData({required this.postData});
}
