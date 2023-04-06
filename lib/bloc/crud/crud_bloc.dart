// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:sample_project/helpers/functions/system_log.dart';
import '../../services/dio_setting.dart';
part 'crud_event.dart';
part 'crud_state.dart';

class CrudBloc extends Bloc<CrudEvent, CrudState> {
  CrudBloc() : super(CrudLoading()) {
    on<ReadData>((event, emit) async {
      try {
        Response response =
            await getConnect('https://reqres.in/api/users', event.page);
        if (response.statusCode == 200) {
          emit(ReadDataSuccess(jsonDecode(response.toString())['data']));
        } else {
          systemLog("Failed to get data");
        }
      } catch (e) {
        systemLog(e.toString());
      }
    });
    on<SendData>((event, emit) async {
      try {
        Response response =
            await postConnect('https://reqres.in/api/users', event.postData);
        if (response.statusCode == 201) {
          systemLog(response.toString());
          emit(SendDataSucces());
        } else {
          systemLog("Failed to send data");
        }
      } catch (e) {
        systemLog(e.toString());
      }
    });
  }
}
