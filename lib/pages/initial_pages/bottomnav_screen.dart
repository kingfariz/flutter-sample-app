import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_project/bloc/crud/crud_bloc.dart';

import '../../helpers/themes.dart';
import '../crud_pages/fuzzy.dart';
import '../crud_pages/hcreate_screen.dart';
import '../crud_pages/hread_screen.dart';
import '../crud_pages/hupdate_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(bottomNavigationBar: customBottomNav(), body: body()));
  }

  Widget body() {
    switch (currentIndex) {
      case 0:
        return BlocProvider(
          create: (context) => CrudBloc(),
          child: const ReadScreen(),
        );
      case 1:
        return BlocProvider(
          create: (context) => CrudBloc(),
          child: const CreateScreen(),
        );
      case 2:
        return const UpdateScreen();
      case 3:
        return const FuzzyScreen();
      default:
        return const ReadScreen();
    }
  }

  Widget customBottomNav() {
    return BottomNavigationBar(
        backgroundColor: whiteColor,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              child: const Icon(Icons.home),
            ),
            label: 'Read',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              child: const Icon(Icons.add),
            ),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              child: const Icon(Icons.update),
            ),
            label: 'Update',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              child: const Icon(Icons.emoji_people),
            ),
            label: 'Fuzzy',
          ),
        ]);
  }
}
