import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../helpers/functions/system_log.dart';
import '../../helpers/themes.dart';
import '../../services/dio_setting.dart';

class ReadScreen extends StatefulWidget {
  const ReadScreen({Key? key}) : super(key: key);

  @override
  State<ReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  late Response response;
  late Map<String, dynamic> jsonResponse;
  List<dynamic> data = [];
  int currentIndex = 1;

  @override
  void initState() {
    super.initState();
    getData('1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (currentIndex < 2) {
              currentIndex++;
            } else {
              currentIndex--;
            }
            getData(currentIndex.toString());
          },
          backgroundColor: primaryColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          child: Stack(
            children: [
              Icon(currentIndex < 2
                  ? Icons.skip_next_outlined
                  : Icons.arrow_back)
            ],
          ),
        ),
        body: Container(
            padding: const EdgeInsets.only(
                top: defaultMargin, right: defaultMargin, left: defaultMargin),
            child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final Map<String, dynamic> item = data[index];
                  return Card(
                    child: ListTile(
                      title: Text(item['email']),
                      subtitle: Text(item['first_name']),
                    ),
                  );
                })));
  }

  void getData(String page) async {
    response = await getConnect('https://reqres.in/api/users', page);
    if (response.statusCode == 200) {
      setState(() {
        jsonResponse = jsonDecode(response.toString());
        data = jsonResponse['data'];
      });
    } else {
      systemLog("Failed to get data");
    }
  }
}
