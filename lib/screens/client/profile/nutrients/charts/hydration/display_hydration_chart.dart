import 'package:fitness_app/screens/client/profile/nutrients/charts/hydration/hydration_chart.dart';
import 'package:fitness_app/screens/client/profile/nutrients/charts/hydration/hydration_series.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DisplayChart extends StatefulWidget {
  const DisplayChart({Key? key}) : super(key: key);

  @override
  State<DisplayChart> createState() => _DisplayChartState();
}

class _DisplayChartState extends State<DisplayChart> {
  final _database = FirebaseDatabase.instance.ref();

  final List<HydrationSeries> data = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _database
          .child('waterInfo')
          .child(FirebaseAuth.instance.currentUser!.uid.toString())
          .limitToLast(7)
          .onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            final allWaterInfo = Map<dynamic, dynamic>.from(
                ((snapshot.data! as DatabaseEvent).snapshot.value ?? {})
                    as Map<dynamic, dynamic>);

            allWaterInfo.forEach((key, value) {
              final yy = key.toString();

              final individualWaterInfo = Map<String, dynamic>.from(value);

              final barItem = HydrationSeries(
                date: key.toString(),
                glassesOfWater:
                    int.parse(individualWaterInfo['water'].toString()),
                barColor: charts.ColorUtil.fromDartColor(Colors.blueAccent),
              );
              data.add(barItem);
            });
          }
        }
        return Center(
          child: HydrationChart(data: data),
        );
      },
    );
  }
}
