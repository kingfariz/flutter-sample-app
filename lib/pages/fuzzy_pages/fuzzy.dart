import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sample_project/helpers/functions/system_log.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import '../../helpers/themes.dart';

class FuzzyVariable {
  String name;
  List<double> fuzzySet;

  FuzzyVariable(this.name, this.fuzzySet);

  double getDegreeOfMembership(double value) {
    if (value <= fuzzySet[0]) {
      return 0;
    } else if (value >= fuzzySet[2]) {
      return 1;
    } else if (value == fuzzySet[1]) {
      return 1;
    } else if (value > fuzzySet[0] && value < fuzzySet[1]) {
      return (value - fuzzySet[0]) / (fuzzySet[1] - fuzzySet[0]);
    } else {
      var extendedRange = [
        fuzzySet[1],
        fuzzySet[2],
        fuzzySet[2] + (fuzzySet[2] - fuzzySet[1])
      ];
      return (extendedRange[2] - value) / (extendedRange[2] - extendedRange[1]);
    }
  }
}

class FuzzyChartData {
  final String variable;
  final double membershipDegree;

  FuzzyChartData(this.variable, this.membershipDegree);
}

class FuzzyScreen extends StatefulWidget {
  const FuzzyScreen({Key? key}) : super(key: key);

  @override
  State<FuzzyScreen> createState() => _FuzzyScreenState();
}

class _FuzzyScreenState extends State<FuzzyScreen> {
  final _formKey = GlobalKey<FormState>();
  double result = 0.0;
  double _valueBehavior = 50.0;
  double _valueWorkPerformance = 50.0;
  double _valueAttendance = 50.0;
  String pernyataan = '';
  List<FuzzyChartData> chartData = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            updateSection(),
          ],
        ),
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
            fuzzyCalculator(
                _valueWorkPerformance, _valueBehavior, _valueAttendance);
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        child: Text(
          'CALCULATE',
          style: primaryTextStyle.copyWith(
              fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
        ),
      ),
    );
  }

  void fuzzyCalculator(double workPerformanceExt, double behaviorExt,
      double attendanceExt) async {
    // Define the fuzzy sets for each variable
    List<double> workPerformanceSet = [40, 70, 100];
    List<double> behaviorSet = [40, 60, 100];
    List<double> attendanceSet = [40, 60, 100];

    // Create the fuzzy variables
    var workPerformance = FuzzyVariable("Work Performance", workPerformanceSet);
    var behavior = FuzzyVariable("Behavior", behaviorSet);
    var attendance = FuzzyVariable("Attendance", attendanceSet);

    // Set the input values for each variable
    var workPerformanceValue = workPerformanceExt;
    var behaviorValue = behaviorExt;
    var attendanceValue = attendanceExt;

    // Evaluate the fuzzy logic for each variable
    var workPerformanceDegreeOfMembership =
        workPerformance.getDegreeOfMembership(workPerformanceValue);
    var behaviorDegreeOfMembership =
        behavior.getDegreeOfMembership(behaviorValue);
    var attendanceDegreeOfMembership =
        attendance.getDegreeOfMembership(attendanceValue);

    // Calculate the degree of membership for each action
    var actionMembership = {
      "Promotion": min<double>(
          min(workPerformanceDegreeOfMembership, behaviorDegreeOfMembership),
          attendanceDegreeOfMembership),
      "Salary Increase": min<double>(
          min(workPerformanceDegreeOfMembership, behaviorDegreeOfMembership),
          1 - attendanceDegreeOfMembership),
      "Contract Continue Without Salary Increase": min<double>(
          1 -
              min(workPerformanceDegreeOfMembership,
                  behaviorDegreeOfMembership),
          attendanceDegreeOfMembership),
      "Fired": min<double>(
          1 -
              min(workPerformanceDegreeOfMembership,
                  behaviorDegreeOfMembership),
          1 - attendanceDegreeOfMembership),
    };

    // Determine the highest degree of membership and the corresponding action
    var highestMembership = actionMembership.values.reduce(max);
    var highestActions = actionMembership.keys
        .where((key) => actionMembership[key] == highestMembership);
    pernyataan = highestActions.first;

    systemLog("\nAction aa: $pernyataan");

    chartData = [
      FuzzyChartData(
          'Promote',
          min<double>(
              min(workPerformanceDegreeOfMembership,
                  behaviorDegreeOfMembership),
              attendanceDegreeOfMembership)),
      FuzzyChartData(
          'Increase Salary',
          min<double>(
              min(workPerformanceDegreeOfMembership,
                  behaviorDegreeOfMembership),
              1 - attendanceDegreeOfMembership)),
      FuzzyChartData(
          'Continue',
          min<double>(
              1 -
                  min(workPerformanceDegreeOfMembership,
                      behaviorDegreeOfMembership),
              attendanceDegreeOfMembership)),
      FuzzyChartData(
          'Fired',
          min<double>(
              1 -
                  min(workPerformanceDegreeOfMembership,
                      behaviorDegreeOfMembership),
              1 - attendanceDegreeOfMembership)),
    ];
    setState(() {});
  }

  updateSection() {
    return Form(
      key: _formKey,
      child: Column(children: [
        const SizedBox(height: 10),
        Text('workPerformance', style: primaryTextStyle),
        const SizedBox(height: 8),
        SfSlider(
          min: 0.0,
          max: 100.0,
          value: _valueWorkPerformance,
          interval: 25,
          showTicks: true,
          showLabels: false,
          enableTooltip: true,
          minorTicksPerInterval: 1,
          onChanged: (dynamic value) {
            setState(() {
              _valueWorkPerformance = value;
            });
          },
        ),
        const SizedBox(
          height: 12,
        ),
        Text('behavior', style: primaryTextStyle),
        SfSlider(
          min: 0.0,
          max: 100.0,
          value: _valueBehavior,
          interval: 25,
          showTicks: true,
          showLabels: false,
          enableTooltip: true,
          minorTicksPerInterval: 1,
          onChanged: (dynamic value) {
            setState(() {
              _valueBehavior = value;
            });
          },
        ),
        const SizedBox(
          height: 12,
        ),
        Text('attendance', style: primaryTextStyle),
        SfSlider(
          min: 0.0,
          max: 100.0,
          value: _valueAttendance,
          interval: 25,
          showTicks: true,
          showLabels: false,
          enableTooltip: true,
          minorTicksPerInterval: 1,
          onChanged: (dynamic value) {
            setState(() {
              _valueAttendance = value;
            });
          },
        ),
        Text(
          'RESULT:\n$pernyataan',
          style: primaryTextStyle.copyWith(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        submitButton(),
        SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            series: <ColumnSeries<FuzzyChartData, String>>[
              ColumnSeries<FuzzyChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (FuzzyChartData data, _) => data.variable,
                  yValueMapper: (FuzzyChartData data, _) =>
                      data.membershipDegree,
                  dataLabelSettings: const DataLabelSettings(isVisible: true))
            ]),
      ]),
    );
  }
}
