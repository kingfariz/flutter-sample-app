import 'package:reactive_forms/reactive_forms.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../helpers/themes.dart';
import '../../../helpers/widgets/form_text_global.dart';
import '../../../models/user_model.dart';
import '../bloc/crud_bloc.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  late Response response;
  late Map<String, dynamic> jsonResponse;
  UserModel userModel = UserModel();

  @override
  void initState() {
    super.initState();
    getData();
  }

  FormGroup buildForm() => fb.group(<String, Object>{
        'name': ['', Validators.required, Validators.minLength(5)],
        'jobs': ['', Validators.required, Validators.minLength(5)],
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.only(right: defaultMargin, left: defaultMargin),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            decelerationRate: ScrollDecelerationRate.fast),
        child: ReactiveFormBuilder(
          form: buildForm,
          builder: (context, formGroup, child) {
            return BlocListener<CrudBloc, CrudState>(
              listener: (context, state) {
                if (state is UpdateDataSuccess) {
                  formGroup.resetState({
                    'name': ControlState<String>(value: null),
                    'jobs': ControlState<String>(value: null),
                  }, removeFocus: true);
                  showSnackbar("Update Data Success");
                }
                if (state is DeleteDataSuccess) {
                  formGroup.resetState({
                    'name': ControlState<String>(value: null),
                    'jobs': ControlState<String>(value: null),
                  }, removeFocus: true);
                  showSnackbar("Delete Data Success");
                }
                if (state is GetDataSuccess) {
                  setState(() {
                    userModel = UserModel.fromJson(state.data);
                  });
                }
                if (state is CrudError) {
                  showSnackbar(
                      "Update Data Failed Please check your connection");
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  updateSection(),
                  submitButton(form: formGroup),
                  deleteButton(),
                ],
              ),
            );
          },
        ),
      ),
    ));
  }

  updateSection() {
    return Column(children: [
      const SizedBox(height: defaultMargin),
      infoSection(),
      const SizedBox(height: 10),
      ReactiveTextField<String>(
        formControlName: 'name',
        validationMessages: {
          ValidationMessage.required: (_) => 'The name must not be empty',
          ValidationMessage.minLength: (_) =>
              'Please enter more than 4 characters'
        },
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          labelText: 'Name',
          helperText: '',
          helperStyle: TextStyle(height: 0.7),
          errorStyle: TextStyle(height: 0.7),
        ),
      ),
      ReactiveTextField<String>(
        formControlName: 'jobs',
        validationMessages: {
          ValidationMessage.required: (_) => 'The Jobs must not be empty',
          ValidationMessage.minLength: (_) =>
              'Please enter more than 4 characters'
        },
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(
          labelText: 'Jobs',
          helperText: '',
          helperStyle: TextStyle(height: 0.7),
          errorStyle: TextStyle(height: 0.7),
        ),
      ),
    ]);
  }

  Widget submitButton({required FormGroup form}) {
    return Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 30),
      child: ElevatedButton(
        onPressed: () async {
          if (form.valid) {
            updateData(
                form.value['name'].toString(), form.value['jobs'].toString());
          } else {
            form.markAllAsTouched();
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
            ? Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 200.0,
                  height: 190.0,
                  color: Colors.white,
                ))
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
    final CrudBloc crudBloc = BlocProvider.of<CrudBloc>(context);
    crudBloc.add(GetData());
  }

  void updateData(String name, String job) async {
    final CrudBloc crudBloc = BlocProvider.of<CrudBloc>(context);
    crudBloc.add(UpdateData(postData: {'name': name, 'job': job}));
  }

  void deleteData() async {
    final CrudBloc crudBloc = BlocProvider.of<CrudBloc>(context);
    crudBloc.add(DeleteData());
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
