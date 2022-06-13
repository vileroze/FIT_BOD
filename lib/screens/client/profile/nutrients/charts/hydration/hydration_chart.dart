import 'package:fitness_app/screens/client/profile/nutrients/charts/hydration/hydration_series.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:google_fonts/google_fonts.dart';

class HydrationChart extends StatelessWidget {
  final List<HydrationSeries> data;
  HydrationChart({required this.data});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<charts.Series<HydrationSeries, String>> series = [
      charts.Series(
        id: "Glasses of water",
        data: data,
        domainFn: (HydrationSeries series, _) => series.date,
        measureFn: (HydrationSeries series, _) => series.glassesOfWater,
        colorFn: (HydrationSeries series, _) => series.barColor,
        insideLabelStyleAccessorFn: (HydrationSeries series, _) =>
            charts.TextStyleSpec(
                color: charts.ColorUtil.fromDartColor(Colors.white)),
        labelAccessorFn: (HydrationSeries series, _) =>
            '${series.glassesOfWater} glass',
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
              'HYDRATION CHART',
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
