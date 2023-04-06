import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sample_project/pages/initial_pages/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sample Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
