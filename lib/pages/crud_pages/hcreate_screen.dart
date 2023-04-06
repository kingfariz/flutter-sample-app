import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../helpers/system_log.dart';
import '../../helpers/themes.dart';
import '../../services/dio_setting.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  TextEditingController nameCtrl = TextEditingController(text: '');
  TextEditingController jobCtrl = TextEditingController(text: '');
  late Response response;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(
            top: defaultMargin, right: defaultMargin, left: defaultMargin),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name', style: primaryTextStyle),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                minLines: 2,
                maxLines: 3,
                maxLength: 300,
                controller: nameCtrl,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Enter Name";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Name',
                    counterText: ''),
              ),
              const SizedBox(
                height: 12,
              ),
              Text('Job', style: primaryTextStyle),
              TextFormField(
                minLines: 2,
                maxLines: 3,
                maxLength: 300,
                controller: jobCtrl,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Enter Job";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Job',
                    counterText: ''),
              ),
              submitButton()
            ],
          ),
        ));
  }

  Widget submitButton() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 30, bottom: 30),
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            sendData(nameCtrl.text.toString(), jobCtrl.text.toString());
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        child: Text(
          'KIRIM',
          style: primaryTextStyle.copyWith(
              fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
        ),
      ),
    );
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: primaryColor,
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void sendData(String name, String job) async {
    var postData = {'name': name, 'job': job};
    response = await postConnect('https://reqres.in/api/users', postData);
    if (response.statusCode == 201) {
      systemLog(response.toString());
      jobCtrl.text = "";
      nameCtrl.text = "";
      setState(() {});
      Future.delayed(const Duration(milliseconds: 200));
      showSnackbar("Success");
    } else {
      systemLog("Failed");
      showSnackbar("Failed to Send Data, Please check your connection");
    }
  }
}
