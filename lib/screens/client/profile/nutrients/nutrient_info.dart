import 'dart:async';

import 'package:fitness_app/extra/color.dart';
import 'package:fitness_app/screens/client/profile/nutrients/calorie_intake.dart';
import 'package:fitness_app/screens/client/profile/nutrients/charts/calories/display_calorie_chart.dart';
import 'package:fitness_app/screens/client/profile/nutrients/charts/hydration/display_hydration_chart.dart';
import 'package:fitness_app/screens/client/profile/nutrients/view_calories.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NutrientInfo extends StatefulWidget {
  const NutrientInfo({Key? key}) : super(key: key);

  @override
  State<NutrientInfo> createState() => _NutrientInfoState();
}

class _NutrientInfoState extends State<NutrientInfo> {
  final Color _accentColor = Color.fromRGBO(231, 88, 20, 1);
  late StreamSubscription _waterUpdateStream;
  final _database = FirebaseDatabase.instance.ref();
  int _currentWater = 0;

  final String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

  void _activateListeners() {
    _database
        .child('waterInfo')
        .child(FirebaseAuth.instance.currentUser!.uid.toString())
        .child(todayDate)
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>);

        int cw = data['water'];

        setState(() {
          _currentWater = cw;
        });
      } else {
        _database
            .child('waterInfo')
            .child(FirebaseAuth.instance.currentUser!.uid.toString())
            .child(todayDate)
            .set({'water': 0});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final waterInfoQuery = _database
        .child('waterInfo')
        .child(FirebaseAuth.instance.currentUser!.uid.toString())
        .child(todayDate)
        .child('water');

    final waterInfoQuery2 = _database
        .child('waterInfo')
        .child(FirebaseAuth.instance.currentUser!.uid.toString())
        .child(todayDate);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.deepOrange[50],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: _accentColor, //change your color here
        ),
        title: Text(
          'NUTRITION',
          style: TextStyle(
            fontSize: size.width / 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
            letterSpacing: 2.0,
            color: _accentColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrange[50],
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: size.height / 20, left: size.width / 20, bottom: 20),
              child: Row(
                children: [
                  Text(
                    'ADD MEAL',
                    style: GoogleFonts.anton(
                      fontSize: size.width / 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                      color: _accentColor,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Tooltip(
                    message:
                        '✅Enter a string containing food or drink items.\n✅If you wish to calculate a specific quantity, you may prefix a quantity before an item.\n✅For example, 3 tomatoes or 1lb beef brisket.\n✅If no quantity is specified, the default quantity is 100 grams. Queries cannot exceed 1500 characters',
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Color.fromRGBO(231, 88, 20, 0.9),
                    ),
                    height: size.height / 15,
                    padding: const EdgeInsets.all(8.0),
                    preferBelow: false,
                    textStyle: TextStyle(
                      fontSize: size.width / 28,
                      color: Colors.white,
                    ),
                    showDuration: const Duration(seconds: 15),
                    // waitDuration: const Duration(seconds: 1),

                    child: Icon(
                      Icons.info_outline,
                      color: Extra.accentColor,
                    ),
                  )
                ],
              ),
            ),
            CalorieIntake(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: size.height / 20, left: size.width / 20),
                  child: Text(
                    'HYDRATION',
                    style: GoogleFonts.anton(
                      fontSize: size.width / 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                      color: _accentColor,
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width / 2.5,
                ),
                Container(
                  margin: EdgeInsets.only(top: size.height / 25),
                  // color: Colors.amber,
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  insetPadding: EdgeInsets.only(
                                      bottom: size.height / 12,
                                      top: size.height / 12,
                                      right: 10,
                                      left: 10),
                                  content: Container(
                                    height: size.height / 1.1,
                                    width: size.width,
                                    child: Column(
                                      children: <Widget>[
                                        DisplayChart(),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        icon: Icon(
                          Icons.bar_chart_rounded,
                          size: size.width / 9,
                          color: Extra.accentColor,
                        ),
                      ),
                      Text(
                        'BAR CHART',
                        style: TextStyle(
                          fontSize: size.width / 40,
                          decorationColor: Extra.accentColor,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 20.0),
              constraints: BoxConstraints(
                minHeight: size.height / 7,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  20.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      child: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/fitnessapp-292ab.appspot.com/o/backgroundImages%2FlineArt%2Fwater.png?alt=media&token=e1f910df-3fd9-4167-b40e-a98b99c924eb'),
                    ),
                  ),
                  SizedBox(
                    width: 90,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        _currentWater.toString(),
                        style: TextStyle(
                          fontSize: size.width / 5,
                          decoration: TextDecoration.underline,
                          decorationColor: Extra.accentColor,
                          decorationThickness: 2,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    // color: Colors.red,
                    width: size.width / 6,
                    child: Column(
                      children: [
                        Container(
                          child: TextButton(
                            child: Text(
                              '+',
                              style: TextStyle(
                                  fontSize: size.width / 9,
                                  color: Extra.accentColor),
                            ),
                            onPressed: () {
                              _waterUpdateStream =
                                  waterInfoQuery.onValue.listen((event) {
                                int waterInfo = 0;

                                waterInfo =
                                    int.parse(event.snapshot.value.toString());

                                waterInfo = waterInfo + 1;

                                waterInfoQuery2.update({'water': waterInfo});
                                _waterUpdateStream.cancel();
                              });
                            },
                          ),
                        ),
                        Container(
                          child: IconButton(
                            icon: Icon(Icons.remove,
                                size: size.width / 12,
                                color: Extra.accentColor),
                            onPressed: _currentWater == 0
                                ? null
                                : () {
                                    _waterUpdateStream =
                                        waterInfoQuery.onValue.listen((event) {
                                      int waterInfo = 0;

                                      waterInfo = int.parse(
                                          event.snapshot.value.toString());

                                      waterInfo = waterInfo - 1;

                                      waterInfoQuery2
                                          .update({'water': waterInfo});
                                      _waterUpdateStream.cancel();
                                    });
                                  },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: size.height / 25, left: size.width / 20, bottom: 20),
                  child: Text(
                    'TODAY\'S CALORIES',
                    style: GoogleFonts.anton(
                      fontSize: size.width / 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                      color: _accentColor,
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width / 5,
                ),
                Container(
                  margin: EdgeInsets.only(top: size.height / 75),
                  // color: Colors.amber,
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  insetPadding: EdgeInsets.only(
                                      bottom: size.height / 12,
                                      top: size.height / 12,
                                      right: 10,
                                      left: 10),
                                  content: Container(
                                    height: size.height / 1.1,
                                    width: size.width,
                                    child: Column(
                                      children: <Widget>[
                                        DisplayCalorie(),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        icon: Icon(
                          Icons.bar_chart_rounded,
                          size: size.width / 9,
                          color: Extra.accentColor,
                        ),
                      ),
                      Text(
                        'BAR CHART',
                        style: TextStyle(
                          fontSize: size.width / 40,
                          decorationColor: Extra.accentColor,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            ViewDiet(),
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    super.deactivate();
  }
}
