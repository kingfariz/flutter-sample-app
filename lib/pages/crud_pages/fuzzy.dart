import 'package:flutter/material.dart';
import 'package:sample_project/helpers/functions/system_log.dart';
import '../../helpers/themes.dart';

class FuzzyVariable {
  String name;
  List<double> fuzzySet;

  FuzzyVariable(this.name, this.fuzzySet);

  double getDegreeOfMembership(double value) {
    if (value <= fuzzySet[0] || value >= fuzzySet[2]) {
      return 0;
    } else if (value == fuzzySet[1]) {
      return 1;
    } else if (value > fuzzySet[0] && value < fuzzySet[1]) {
      return (value - fuzzySet[0]) / (fuzzySet[1] - fuzzySet[0]);
    } else {
      return (fuzzySet[2] - value) / (fuzzySet[2] - fuzzySet[1]);
    }
  }
}

class FuzzyScreen extends StatefulWidget {
  const FuzzyScreen({Key? key}) : super(key: key);

  @override
  State<FuzzyScreen> createState() => _FuzzyScreenState();
}

class _FuzzyScreenState extends State<FuzzyScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController workPerformanceCtrl = TextEditingController(text: '');
  TextEditingController behaviorCtrl = TextEditingController(text: '');
  TextEditingController attendanceCtrl = TextEditingController(text: '');
  double result = 0.0;
  String pernyataan = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          updateSection(),
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
            fuzzyCalculator(workPerformanceCtrl.text.toString(),
                behaviorCtrl.text.toString(), attendanceCtrl.text.toString());
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

  void fuzzyCalculator(String workPerformanceExt, String behaviorExt,
      String attendanceExt) async {
    // Define the fuzzy sets for each variable
    List<double> workPerformanceSet = [0, 50, 100];
    List<double> behaviorSet = [0, 5, 10];
    List<double> attendanceSet = [0, 50, 100];

    // Create the fuzzy variables
    var workPerformance = FuzzyVariable("Work Performance", workPerformanceSet);
    var behavior = FuzzyVariable("Behavior", behaviorSet);
    var attendance = FuzzyVariable("Attendance", attendanceSet);

    // Set the input values for each variable
    var workPerformanceValue = double.parse(workPerformanceExt);
    var behaviorValue = double.parse(behaviorExt);
    var attendanceValue = double.parse(attendanceExt);

    // Evaluate the fuzzy logic for each variable
    var workPerformanceDegreeOfMembership =
        workPerformance.getDegreeOfMembership(workPerformanceValue);
    var behaviorDegreeOfMembership =
        behavior.getDegreeOfMembership(behaviorValue);
    var attendanceDegreeOfMembership =
        attendance.getDegreeOfMembership(attendanceValue);

    // Print the output values for each variable
    systemLog("Work Performance: $workPerformanceDegreeOfMembership");
    systemLog("Behavior: $behaviorDegreeOfMembership");
    systemLog("Attendance: $attendanceDegreeOfMembership");

    result = ((((workPerformanceDegreeOfMembership +
                    behaviorDegreeOfMembership +
                    attendanceDegreeOfMembership) /
                3) -
            1) *
        -100);
    systemLog("result:${result.round()}");

    if (result.round() > 90) {
      pernyataan = "PROMOTION";
    } else if (result.round() > 80) {
      pernyataan = "SALARY INCREASE";
    } else if (result.round() > 60) {
      pernyataan = "CONTRACT CONTINUE";
    } else {
      pernyataan = "FIRED";
    }
    setState(() {});
  }

  updateSection() {
    return Form(
      key: _formKey,
      child: Column(children: [
        const SizedBox(height: 10),
        Text('workPerformance', style: primaryTextStyle),
        const SizedBox(height: 8),
        TextFormField(
          minLines: 2,
          maxLines: 3,
          maxLength: 300,
          controller: workPerformanceCtrl,
          validator: (value) {
            if (value!.isEmpty) {
              return "Please Enter Name";
            } else {
              return null;
            }
          },
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'workPerformance',
              counterText: ''),
        ),
        const SizedBox(
          height: 12,
        ),
        Text('behavior', style: primaryTextStyle),
        TextFormField(
          minLines: 2,
          maxLines: 3,
          maxLength: 300,
          controller: behaviorCtrl,
          validator: (value) {
            if (value!.isEmpty) {
              return "Please Enter Job";
            } else {
              return null;
            }
          },
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'behavior',
              counterText: ''),
        ),
        const SizedBox(
          height: 12,
        ),
        Text('attendance', style: primaryTextStyle),
        TextFormField(
          minLines: 2,
          maxLines: 3,
          maxLength: 300,
          controller: attendanceCtrl,
          validator: (value) {
            if (value!.isEmpty) {
              return "Please Enter Job";
            } else {
              return null;
            }
          },
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'attendance',
              counterText: ''),
        ),
        Text('RESULT $result', style: primaryTextStyle.copyWith(fontSize: 20)),
        Text('DESCRIPTION $pernyataan',
            style: primaryTextStyle.copyWith(fontSize: 20)),
        submitButton()
      ]),
    );
  }
}
