import 'package:fitness_app/screens/client/profile/nutrients/charts/calories/calorie_chart.dart';
import 'package:fitness_app/screens/client/profile/nutrients/charts/calories/calorie_series.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DisplayCalorie extends StatefulWidget {
  const DisplayCalorie({Key? key}) : super(key: key);

  @override
  State<DisplayCalorie> createState() => _DisplayCalorieState();
}

class _DisplayCalorieState extends State<DisplayCalorie> {
  final _database = FirebaseDatabase.instance.ref();

  List<CalorieSeries> data = [];
  // List<charts.Series<CalorieSeries, String>> _nutritionData{};

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _database
          .child('dietInfo')
          .child(FirebaseAuth.instance.currentUser!.uid.toString())
          .limitToLast(7)
          .onValue,
      builder: (context, snapshot) {
        String year = '';
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            final allWaterInfo = Map<dynamic, dynamic>.from(
                ((snapshot.data! as DatabaseEvent).snapshot.value ?? {})
                    as Map<dynamic, dynamic>);

            allWaterInfo.forEach((key, value) {
              final individualWaterInfo = Map<String, dynamic>.from(value);
              year = key.toString();
              double totalCal = 0;
              double totalProtein = 0;
              double totalCarbs = 0;
              individualWaterInfo.forEach((key, value) {
                final ind = Map<String, dynamic>.from(value);

                totalCal += double.parse(
                    double.parse(ind['calories'].toString())
                        .toStringAsFixed(2));
                totalProtein = double.parse(
                    double.parse(ind['protein'].toString()).toStringAsFixed(2));
                totalCarbs = double.parse(
                    double.parse(ind['carb'].toString()).toStringAsFixed(2));

                final barItem = CalorieSeries(
                  date: year,
                  calories: totalCal,
                  barColor: charts.ColorUtil.fromDartColor(Colors.amber),
                );
                data.add(barItem);
              });
            });
          }
        }

        return Center(
          child: CalorieChart(data: data),
        );
      },
    );
  }
}
