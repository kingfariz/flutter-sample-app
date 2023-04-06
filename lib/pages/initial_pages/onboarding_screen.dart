import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import '../../helpers/themes.dart';
import 'bottomnav_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

List<ContentConfig> listContentConfig = [];

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();
    addListContent();
  }

  addListContent() async {
    listContentConfig.add(
      const ContentConfig(
        title: "Let's Code",
        description: "A Sample Flutter Project",
        pathImage: "assets/flutter_logo.png",
        backgroundColor: primaryColor,
      ),
    );
    listContentConfig.add(
      const ContentConfig(
        title: "CRUD SAMPLE",
        description: "App receive response from reqres",
        pathImage: "assets/image_people.png",
        backgroundColor: primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: true,
      child: IntroSlider(
        key: UniqueKey(),
        listContentConfig: listContentConfig,
        skipButtonStyle: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),
        doneButtonStyle: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),
        nextButtonStyle: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),
        onDonePress: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const BottomNavScreen()));
        },
      ),
    );
  }
}
