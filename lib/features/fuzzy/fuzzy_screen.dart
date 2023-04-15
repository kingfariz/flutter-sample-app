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
      margin: const EdgeInsets.only(
          left: defaultMargin, right: defaultMargin, top: 30),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Employees performance calculator',
              style: primaryBigTextStyle,
              textAlign: TextAlign.center,
            ),
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
          fuzzyCalculator(
              _valueWorkPerformance, _valueBehavior, _valueAttendance);
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
    // Set the input values for each variable
    var workPerformanceValue = workPerformanceExt;
    var behaviorValue = behaviorExt;
    var attendanceValue = attendanceExt;

    // Define the fuzzy sets for each input variable
    List<double> workPerformanceSet = [40, 70, 100];
    List<double> behaviorSet = [50, 80, 100];
    List<double> attendanceSet = [30, 60, 100];

    // Define the fuzzy sets for the output variable
    List<double> promoteSet = [0, 50, 100];
    List<double> increaseSalarySet = [0, 50, 100];
    List<double> firedSet = [0, 50, 100];

    // Create the fuzzy variables for the input and output variables
    var workPerformance = FuzzyVariable("Work Performance", workPerformanceSet);
    var behavior = FuzzyVariable("Behavior", behaviorSet);
    var attendance = FuzzyVariable("Attendance", attendanceSet);

    // Evaluate the degree of membership for each input variable
    var workPerformanceDegreeOfMembership =
        workPerformance.getDegreeOfMembership(workPerformanceValue);
    var behaviorDegreeOfMembership =
        behavior.getDegreeOfMembership(behaviorValue);
    var attendanceDegreeOfMembership =
        attendance.getDegreeOfMembership(attendanceValue);

    // Evaluate the rules and determine the degree of membership of the output variable
    var promoteMembership = min(
        min(workPerformanceDegreeOfMembership, behaviorDegreeOfMembership),
        attendanceDegreeOfMembership);
    var increaseSalaryMembership = min(
        min(workPerformanceDegreeOfMembership, behaviorDegreeOfMembership),
        1 - attendanceDegreeOfMembership);
    var firedMembership = min(
        1 - min(workPerformanceDegreeOfMembership, behaviorDegreeOfMembership),
        attendanceDegreeOfMembership);

    // Define the output fuzzy sets
    var promoteOutput = [0, 50, 100];
    var increaseSalaryOutput = [0, 50, 100];
    var firedOutput = [0, 50, 100];

    // Calculate the centroid of each output fuzzy set
    var promoteCentroid = 0.0;
    var increaseSalaryCentroid = 0.0;
    var firedCentroid = 0.0;

    var promoteMembershipSum =
        promoteMembership + increaseSalaryMembership + firedMembership;

    if (promoteMembershipSum != 0) {
      promoteCentroid = (promoteOutput[0] * promoteMembership +
              promoteOutput[1] * promoteMembership +
              promoteOutput[2] * promoteMembership) /
          promoteMembershipSum;
    } else {
      promoteCentroid = promoteSet[1];
    }

    var increaseSalaryMembershipSum =
        promoteMembership + increaseSalaryMembership + firedMembership;
    if (increaseSalaryMembershipSum != 0) {
      increaseSalaryCentroid =
          (increaseSalaryOutput[0] * increaseSalaryMembership +
                  increaseSalaryOutput[1] * increaseSalaryMembership +
                  increaseSalaryOutput[2] * increaseSalaryMembership) /
              increaseSalaryMembershipSum;
    } else {
      increaseSalaryCentroid = increaseSalarySet[1];
    }
    var firedMembershipSum =
        promoteMembership + increaseSalaryMembership + firedMembership;
    if (firedMembershipSum != 0) {
      firedCentroid = (firedOutput[0] * firedMembership +
              firedOutput[1] * firedMembership +
              firedOutput[2] * firedMembership) /
          firedMembershipSum;
    } else {
      firedCentroid = firedSet[1];
    }

    // Print the output
    systemLog("workPerformanceValue: $workPerformanceExt");
    systemLog("behaviorValue: $behaviorExt");
    systemLog("attendanceValue: $attendanceExt");
    // Print the output
    systemLog("Promote: $promoteCentroid");
    systemLog("Increase Salary: $increaseSalaryCentroid");
    systemLog("Fired: $firedCentroid");

    determineResult(minusChecker(promoteCentroid),
        minusChecker(increaseSalaryCentroid), minusChecker(firedCentroid));
    chartData = [
      FuzzyChartData('Promote', minusChecker(promoteCentroid)),
      FuzzyChartData('Increase Salary', minusChecker(increaseSalaryCentroid)),
      FuzzyChartData('Fired', minusChecker(firedCentroid)),
    ];
    setState(() {});
  }

  determineResult(double valA, valB, valC) {
    pernyataan = "Promote";

    if (valB > valA) {
      valA = valB;
      pernyataan = "Increase Salary";
    }

    if (valC > valA) {
      valA = valC;
      pernyataan = "Fired";
    }
  }

  double minusChecker(double value) {
    if (value < 0) {
      value = value * -1;
    }
    return value;
  }

  updateSection() {
    return Column(children: [
      const SizedBox(height: 20),
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
                yValueMapper: (FuzzyChartData data, _) => data.membershipDegree,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]),
    ]);
  }
}
