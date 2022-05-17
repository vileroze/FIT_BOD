import 'package:charts_flutter/flutter.dart' as charts;

class HydrationSeries {
  final String date;
  final int glassesOfWater;
  final charts.Color barColor;

  HydrationSeries(
      {required this.date,
      required this.glassesOfWater,
      required this.barColor});
}
