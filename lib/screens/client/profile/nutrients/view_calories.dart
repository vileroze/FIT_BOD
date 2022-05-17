import 'package:fitness_app/extra/color.dart';
import 'package:fitness_app/screens/client/profile/nutrients/view_calorie_helper.dart';
import 'package:fitness_app/screens/trainer/profile/classes/class_helper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewDiet extends StatefulWidget {
  const ViewDiet({Key? key}) : super(key: key);

  @override
  State<ViewDiet> createState() => _ViewDietState();
}

class _ViewDietState extends State<ViewDiet> {
  final _database = FirebaseDatabase.instance.ref();
  final String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  bool booked = false;
  final helperClass = ClassesHelper();
  // final calHelper = ViewCalorieHelper();

  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

  void _activateListeners() {}

  @override
  Widget build(BuildContext context) {
    final _database = FirebaseDatabase.instance.ref();

    Size size = MediaQuery.of(context).size;

    return StreamBuilder(
      stream: _database
          .child('dietInfo/' +
              FirebaseAuth.instance.currentUser!.uid +
              '/' +
              todayDate +
              '/')
          .onValue,
      builder: (context, snapshot) {
        final foodItemCards = <ViewCalorieHelper>[];
        double totalCal = 0;
        double totalProtein = 0;
        double totalCarbs = 0;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            final allfoodItems = Map<dynamic, dynamic>.from(
                ((snapshot.data! as DatabaseEvent).snapshot.value ?? {})
                    as Map<dynamic, dynamic>);

            allfoodItems.forEach(
              (key, value) {
                String foodKey = key.toString();
                final individualitem = Map<String, dynamic>.from(value);

                totalCal += double.parse(individualitem['calories'].toString());
                totalProtein +=
                    double.parse(individualitem['protein'].toString());
                totalCarbs += double.parse(individualitem['carb'].toString());

                final citem = ViewCalorieHelper(
                  servingSize: individualitem['servingSize'].toString(),
                  food: individualitem['food'].toString(),
                  protein: individualitem['protein'].toString(),
                  carb: individualitem['carb'].toString(),
                  calories: individualitem['calories'].toString(),
                  foodKey: foodKey,
                );
                foodItemCards.add(citem);
              },
            );
          }
        }
        return Column(
          children: [
            ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: foodItemCards,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'Calories -  ' +
                        ((totalCal * 0.129598).toStringAsFixed(2)).toString() +
                        ' gm, Protein - ' +
                        totalProtein.toStringAsFixed(2).toString() +
                        ' gm, Carbs - ' +
                        totalCarbs.toStringAsFixed(2).toString() +
                        ' gm',
                    style: GoogleFonts.mulish(
                      fontWeight: FontWeight.w700,
                      color: Extra.accentColor,
                      fontSize: size.width / 35,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
