import 'package:charts_flutter/flutter.dart' as charts;

class CalorieSeries {
  final String date;
  final double calories;
  final charts.Color barColor;

  CalorieSeries(
      {required this.date, required this.calories, required this.barColor});
}
