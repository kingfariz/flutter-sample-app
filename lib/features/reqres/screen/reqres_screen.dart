import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_project/features/reqres/screen/hcreate_screen.dart';
import 'package:sample_project/features/reqres/screen/hread_screen.dart';
import 'package:sample_project/features/reqres/screen/hupdate_screen.dart';

import '../../../helpers/themes.dart';
import '../bloc/crud_bloc.dart';
import '../page_indicator.dart';

class ReqresScreen extends StatefulWidget {
  const ReqresScreen({super.key});
  @override
  State<ReqresScreen> createState() => _ReqresScreenState();
}

class _ReqresScreenState extends State<ReqresScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double heightFromWhiteBg = 600;
    return Container(
      height: MediaQuery.of(context).size.height,
      color: primaryColor,
      child: Stack(
        children: [
          Container(
            height: 200.0,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: FittedBox(
              child: SizedBox(
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Align(
                      alignment: Alignment.centerRight,
                      child: CircleAvatar(
                        backgroundImage: AssetImage("assets/flutter_logo.png"),
                      ),
                    ),
                    const PageIndicator(activePage: 1),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Hii, This is Reqres Sample Screen",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.77),
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Text(
                      "Choose Reqres\nAPI",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35.0,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 200.0,
            width: size.width,
            child: Container(
              height: heightFromWhiteBg,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
            ),
          ),
          Positioned(
            top: 200.0,
            height: heightFromWhiteBg,
            width: size.width,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                    create: (context) => CrudBloc(),
                                    child: const ReadScreen(),
                                  )));
                    },
                    child: Text("Read Screen", style: buttonTextStyle)),
                const SizedBox(height: 20),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                    create: (context) => CrudBloc(),
                                    child: const CreateScreen(),
                                  )));
                    },
                    child: Text("Create Screen", style: buttonTextStyle)),
                const SizedBox(height: 20),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                    create: (context) => CrudBloc(),
                                    child: const UpdateScreen(),
                                  )));
                    },
                    child: Text("Update Screen", style: buttonTextStyle)),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
