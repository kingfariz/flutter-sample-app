import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/crud/crud_bloc.dart';
import '../../helpers/themes.dart';

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
    return BlocListener<CrudBloc, CrudState>(
      listener: (context, state) {
        if (state is SendDataSucces) {
          setState(() {
            jobCtrl.text = "";
            nameCtrl.text = "";
          });
          showSnackbar("Success");
        }
        if (state is CrudError) {
          showSnackbar("Failed to Send Data, Please check your connection");
        }
      },
      child: Container(
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
          )),
    );
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
          'SEND',
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
    final CrudBloc crudBloc = BlocProvider.of<CrudBloc>(context);
    crudBloc.add(SendData(postData: {'name': name, 'job': job}));
  }
}
