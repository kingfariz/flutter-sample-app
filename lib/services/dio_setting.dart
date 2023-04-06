import 'package:dio/dio.dart';

import '../helpers/functions/system_log.dart';

final Dio dio = Dio(BaseOptions(
    // baseUrl: 'https://reqres.in/api/',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30)));

Future<Response> getConnect(url, page) async {
  try {
    return await dio.get(url + '?page=' + page);
  } on DioError catch (e) {
    systemLog(e.toString());
    rethrow;
  }
}

Future<Response> postConnect(url, data) async {
  try {
    dio.options.headers['content-Type'] = 'application/x-www-form-urlencoded';
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    return await dio.post(url, data: data);
  } on DioError catch (e) {
    systemLog(e.toString());
    rethrow;
  }
}

Future<Response> userGet(url) async {
  try {
    return await dio.get(url);
  } on DioError catch (e) {
    systemLog(e.toString());
    rethrow;
  }
}

Future<Response> userDelete(url) async {
  try {
    return await dio.delete(url);
  } on DioError catch (e) {
    systemLog(e.toString());
    rethrow;
  }
}

Future<Response> userUpdate(url, data) async {
  try {
    dio.options.headers['content-Type'] = 'application/x-www-form-urlencoded';
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    return await dio.put(url, data: data);
  } on DioError catch (e) {
    systemLog(e.toString());
    rethrow;
  }
}
