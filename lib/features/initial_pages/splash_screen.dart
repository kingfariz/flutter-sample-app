import 'package:flutter/material.dart';
import '../../helpers/themes.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    changePage();
  }

  Future changePage() async {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 60),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/sample_project.png'),
            ),
          ),
        ),
      ),
    );
  }
}
