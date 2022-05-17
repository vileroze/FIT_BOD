import 'dart:async';
import 'package:fitness_app/screens/client/profile/nutrients/nutrient_info.dart';
import 'package:fitness_app/screens/client/profile/stepCounter/step_counter.dart';
import 'package:fitness_app/screens/client/settings/profile_setting.dart';
import 'package:recase/recase.dart';

import 'package:fitness_app/screens/client/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/screens/client/profile/schedule/schedule.dart';
import 'package:fitness_app/screens/client/profile/workout/workout.dart';
import 'package:fitness_app/screens/client/profile/mealplan/mealplan.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _database = FirebaseDatabase.instance.ref();
  String _userName = "Unknown";
  String _userUrl = "";
  String userID = FirebaseAuth.instance.currentUser!.uid;
  String _userInfoPath = "";
  late StreamSubscription _userInfoStream;

  int numClasses = 0;
  bool schedulePressed = false;
  bool workoutPressed = false;
  bool mealplanPressed = false;
  final FocusNode focusNode = FocusNode();

  final _width = 383.0;
  final Color _accentColor = Color.fromRGBO(231, 88, 20, 1);

  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

  void _activateListeners() {
    schedulePressed = true;
    _userInfoPath = "userDetails/" + userID.trim() + "/";

    _userInfoStream =
        _database.child(_userInfoPath.trim()).onValue.listen((event) {
      final data = Map<String, dynamic>.from(
          event.snapshot.value as Map<dynamic, dynamic>);

      final uName = data['userName'] as String;
      final uUrl = data['profileImgUrl'] as String;
      final totalCourse = data['coursesTaken'] as int;

      setState(() {
        _userName = uName;
        _userUrl = uUrl;
        numClasses = totalCourse;
        Mealplan();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // final userDetailsRef = _database.child('/userDetails');
    Size size = MediaQuery.of(context).size;
    double subHeading = size.width / 33;
    ScrollController _controller = ScrollController();

    void _animateToIndex(int index) {
      _controller.animateTo(
        index * _width,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }

    return Scaffold(
      backgroundColor: Colors.deepOrange[50],
      appBar: AppBar(
        title: Text(
          'PROFILE',
          style: TextStyle(
            fontSize: size.width / 30,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
            letterSpacing: 2.0,
            color: _accentColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrange[50],
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settings()),
                );
              },
              icon: Icon(
                Icons.settings_outlined,
                color: Colors.deepOrange.shade500,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          size.width / 25, (size.width / 30), 0, 0),
                      child: Text(
                        _userName.titleCase,
                        style: TextStyle(
                          fontSize: size.width / 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                          letterSpacing: 1.0,
                          color: _accentColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          size.width / 25, size.width / 30, 0, 0),
                      child: Text(
                        '$numClasses Total Classes',
                        style: TextStyle(
                          // fontSize: 17.0,
                          fontSize: size.width / 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                          letterSpacing: 1.0,
                          color: _accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: CircleAvatar(
                    backgroundImage: (_userUrl == '')
                        ? AssetImage('assets/profile/random_profile.jpg')
                            as ImageProvider
                        : NetworkImage(_userUrl),
                    radius: size.width / 7,
                    backgroundColor: Colors.deepOrange[500],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: size.width / 25, bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Focus(
                    child: TextButton(
                      autofocus: true,
                      focusNode: focusNode,
                      onPressed: () {
                        _animateToIndex(0);
                        setState(() {
                          schedulePressed = true;
                          workoutPressed = false;
                          mealplanPressed = false;
                        });
                      },
                      child: Text(
                        "SCHEDULE",
                        style: TextStyle(
                          letterSpacing: 1,
                          fontSize: subHeading,
                          color: schedulePressed
                              ? _accentColor
                              : Color.fromRGBO(231, 88, 20, 0.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _animateToIndex(1);
                      setState(() {
                        schedulePressed = false;
                        workoutPressed = true;
                        mealplanPressed = false;
                      });
                    },
                    child: Text(
                      "WORKOUTS",
                      style: TextStyle(
                        letterSpacing: 1,
                        fontSize: subHeading,
                        color: workoutPressed
                            ? _accentColor
                            : Color.fromRGBO(231, 88, 20, 0.5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _animateToIndex(3);
                      setState(() {
                        schedulePressed = false;
                        workoutPressed = false;
                        mealplanPressed = true;
                      });
                    },
                    child: Text(
                      "MEALPLANS",
                      style: TextStyle(
                        letterSpacing: 1,
                        fontSize: subHeading,
                        color: mealplanPressed
                            ? _accentColor
                            : Color.fromRGBO(231, 88, 20, 0.5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              controller: _controller,
              child: Row(
                children: <Widget>[
                  Container(
                    height: size.height / 1.745,
                    width: size.width,
                    child: Schedule(),
                  ),
                  Container(
                    height: size.height / 1.745,
                    width: size.width,
                    child: Workout(),
                  ),
                  Container(
                    height: size.height / 1.745,
                    width: size.width,
                    child: Mealplan(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        // color: Colors.black,
        constraints: BoxConstraints(
          maxHeight: size.height / 1.87,
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.end,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: FloatingActionButton(
                heroTag: 'updateProfile',
                backgroundColor: Color.fromARGB(255, 240, 113, 54),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileSettings()),
                  );
                },
                child: Icon(Icons.account_circle),
              ),
            ),
            Container(
              // color: Colors.redAccent,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: FloatingActionButton(
                  heroTag: 'waterIntake',
                  backgroundColor: Color.fromARGB(255, 240, 113, 54),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NutrientInfo()),
                    );
                  },
                  child: Icon(Icons.water_drop_sharp),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: FloatingActionButton(
                heroTag: 'stepCounter',
                backgroundColor: Color.fromARGB(255, 240, 113, 54),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DailyStepsPage()),
                  );
                },
                child: Icon(Icons.directions_walk),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    _userInfoStream.cancel();
    super.deactivate();
  }
}
