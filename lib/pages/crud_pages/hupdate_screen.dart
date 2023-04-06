import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/crud/crud_bloc.dart';
import '../../models/user_model.dart';
import '../../helpers/widgets/form_text_global.dart';
import '../../helpers/functions/system_log.dart';
import '../../helpers/themes.dart';
import '../../services/dio_setting.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  late Response response;
  late Map<String, dynamic> jsonResponse;
  UserModel userModel = UserModel();
  TextEditingController nameCtrl = TextEditingController(text: '');
  TextEditingController jobCtrl = TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.only(right: defaultMargin, left: defaultMargin),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            decelerationRate: ScrollDecelerationRate.fast),
        child: BlocListener<CrudBloc, CrudState>(
          listener: (context, state) {
            if (state is SendDataSuccess) {
              setState(() {
                jobCtrl.text = "";
                nameCtrl.text = "";
              });
              showSnackbar("Update Data Success");
            }
            if (state is CrudError) {
              showSnackbar("Update Data Failed Please check your connection");
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: defaultMargin),
              infoSection(),
              updateSection(),
              deleteButton(),
            ],
          ),
        ),
      ),
    ));
  }

  updateSection() {
    return Form(
      key: _formKey,
      child: Column(children: [
        const SizedBox(height: 10),
        Text('Name', style: primaryTextStyle),
        const SizedBox(height: 8),
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
              border: OutlineInputBorder(), hintText: 'Name', counterText: ''),
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
              border: OutlineInputBorder(), hintText: 'Job', counterText: ''),
        ),
        submitButton()
      ]),
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
            updateData(nameCtrl.text.toString(), jobCtrl.text.toString());
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        child: Text(
          'UPDATE',
          style: primaryTextStyle.copyWith(
              fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
        ),
      ),
    );
  }

  Widget deleteButton() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 30, bottom: 30),
      child: ElevatedButton(
        onPressed: () async {
          deleteData();
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: redColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        child: Text(
          'DELETE',
          style: primaryTextStyle.copyWith(
              fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
        ),
      ),
    );
  }

  infoSection() {
    return Column(
      children: [
        userModel.avatarUrl == ""
            ? const Icon(
                Icons.timelapse_outlined,
                size: 80,
              )
            : Image.network(
                userModel.avatarUrl,
                fit: BoxFit.fill,
                height: 200,
                width: 190,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
        const SizedBox(
          height: 20,
        ),
        formTextGlobal(text: "First Name: ${userModel.firstName}"),
        formTextGlobal(text: "Last Name: ${userModel.lastName}"),
        formTextGlobal(text: "Email: ${userModel.email}"),
      ],
    );
  }

  void getData() async {
    response = await userGet('https://reqres.in/api/users/2');
    if (response.statusCode == 200) {
      systemLog(response.data["data"].toString());
      setState(() {
        userModel = UserModel.fromJson(jsonDecode(response.toString()));
      });
    } else {
      systemLog("Failed to get data");
    }
  }

  void updateData(String name, String job) async {
    final CrudBloc crudBloc = BlocProvider.of<CrudBloc>(context);
    crudBloc.add(UpdateData(postData: {'name': name, 'job': job}));
  }

  void deleteData() async {
    response = await userDelete('https://reqres.in/api/users/2');
    if (response.statusCode == 204) {
      jobCtrl.text = "";
      nameCtrl.text = "";
      setState(() {});
      Future.delayed(const Duration(milliseconds: 200));
      systemLog("Mendapat response ${response.statusCode}");
      showSnackbar("Berhasil Delete Data");
    } else {
      systemLog("gagal Delete data");
      showSnackbar("Gagal Delete Data");
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor:
            message.toLowerCase().contains("delete") ? redColor : primaryColor,
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
