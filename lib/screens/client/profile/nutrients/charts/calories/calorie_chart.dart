import 'package:fitness_app/screens/client/profile/nutrients/charts/calories/calorie_series.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:google_fonts/google_fonts.dart';

class CalorieChart extends StatelessWidget {
  final List<CalorieSeries> data;
  CalorieChart({required this.data});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<charts.Series<CalorieSeries, String>> series = [
      charts.Series(
        id: "Glasses of water",
        data: data,
        domainFn: (CalorieSeries series, _) => series.date,
        measureFn: (CalorieSeries series, _) => series.calories,
        colorFn: (CalorieSeries series, _) => series.barColor,
        insideLabelStyleAccessorFn: (CalorieSeries series, _) =>
            charts.TextStyleSpec(
                color: charts.ColorUtil.fromDartColor(Colors.black)),
        labelAccessorFn: (CalorieSeries series, _) =>
            '${series.calories.toStringAsFixed(2)} cal',
      ),
    ];
    return Container(
      height: size.height / 1.5,
      width: size.width,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Column(
          children: <Widget>[
            Text(
              'CAL0RIE CHART',
              style: GoogleFonts.anton(fontSize: 20),
            ),
            Expanded(
              child: charts.BarChart(
                series,
                animate: true,
                vertical: false,
                barRendererDecorator: charts.BarLabelDecorator<String>(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
