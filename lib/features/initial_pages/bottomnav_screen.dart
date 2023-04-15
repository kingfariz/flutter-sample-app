import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../helpers/themes.dart';
import '../ecommerce/screen/ecommerce_screen.dart';
import '../reqres/screen/hupdate_screen.dart';
import '../reqres/screen/reqres_screen.dart';
import '../ecommerce/bloc/product_bloc.dart';
import '../fuzzy/fuzzy_screen.dart';
import '../reqres/bloc/crud_bloc.dart';
import '../reqres/screen/hcreate_screen.dart';
import '../reqres/screen/hread_screen.dart';

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
            create: (context) => CrudBloc(), child: const ReqresScreen());

      case 1:
        return BlocProvider(
          create: (context) => ProductBloc()..add(LoadProductEvent()),
          child: const EcommercePage(),
        );
      case 2:
        return const FuzzyScreen();
      default:
        return const ReqresScreen();
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
            label: 'Reqres API',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Ecommerce',
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
