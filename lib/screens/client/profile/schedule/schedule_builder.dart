import 'dart:async';
import 'package:fitness_app/extra/button_styles.dart';
import 'package:fitness_app/extra/color.dart';
import 'package:fitness_app/screens/client/profile/schedule/schedule_helper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class BookedCourses extends StatefulWidget {
  const BookedCourses({Key? key}) : super(key: key);

  @override
  State<BookedCourses> createState() => _BookedCoursesState();
}

class _BookedCoursesState extends State<BookedCourses> {
  final _database = FirebaseDatabase.instance.ref();
  final Color _accentColor = Color.fromRGBO(231, 88, 20, 1);

  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  String classesToday = 'today';

  bool booked = false;
  final helperClass = ScheduleHelper();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String formatted = formatter.format(now);
    DateTime todayDate = DateFormat("yyyy-MM-dd").parse(formatted);

    Size size = MediaQuery.of(context).size;
    final tilesList = <ListTile>[];
    tilesList.add(ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 180.0,
            child: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/fitnessapp-292ab.appspot.com/o/backgroundImages%2FlineArt%2Fschedule.png?alt=media&token=127ca6fd-d822-4d72-ae5b-ccb71c58d0d6'),
          ),
          SizedBox(
            width: 13,
          ),
          Column(
            children: [
              TextButton(
                style: pill(Colors.white, Extra.accentColor, 30.0),
                onPressed: () {
                  setState(() {
                    classesToday = 'today';
                  });
                },
                child: Text('TODAY'),
              ),
              TextButton(
                style: pill(Colors.white, Extra.accentColor, 30.0),
                onPressed: () {
                  setState(() {
                    classesToday = 'upcoming';
                  });
                },
                child: Text('UPCOMING'),
              ),
              TextButton(
                style: pill(Colors.white, Extra.accentColor, 30.0),
                onPressed: () {
                  setState(() {
                    classesToday = 'all';
                  });
                },
                child: Text('HISTORY'),
              ),
            ],
          )
        ],
      ),
    ));

    return StreamBuilder(
      stream: _database
          .child('course/' + FirebaseAuth.instance.currentUser!.uid + '/')
          .onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            final allClasses = Map<dynamic, dynamic>.from(
                ((snapshot.data! as DatabaseEvent).snapshot.value ?? {})
                    as Map<dynamic, dynamic>);

            allClasses.forEach((key, value) {
              final individualCourse = Map<String, dynamic>.from(value);

              // print(individualCourse['date'].toString());

              if (classesToday.trim() != 'all') {
                if (classesToday == 'today') {
                  if (formatted == individualCourse['date'].toString()) {
                    helperClass.addTilesToList(
                      tilesList,
                      individualCourse['startTime'].toString(),
                      individualCourse['duration'].toString(),
                      individualCourse['category'].toString(),
                      individualCourse['name'].toString(),
                      individualCourse['instructor'].toString(),
                      individualCourse['price'].toString(),
                      individualCourse['date'].toString(),
                      individualCourse['channelName'].toString(),
                      size,
                    );
                  }
                }

                if (classesToday.trim() == 'upcoming') {
                  if (DateFormat("yyyy-MM-dd")
                          .parse(individualCourse['date'].toString())
                          .compareTo(todayDate) >
                      0) {
                    helperClass.addTilesToList(
                      tilesList,
                      individualCourse['startTime'].toString(),
                      individualCourse['duration'].toString(),
                      individualCourse['category'].toString(),
                      individualCourse['name'].toString(),
                      individualCourse['instructor'].toString(),
                      individualCourse['price'].toString(),
                      individualCourse['date'].toString(),
                      individualCourse['channelName'].toString(),
                      size,
                    );
                  }
                }
              } else {
                helperClass.addTilesToList(
                  tilesList,
                  individualCourse['startTime'].toString(),
                  individualCourse['duration'].toString(),
                  individualCourse['category'].toString(),
                  individualCourse['name'].toString(),
                  individualCourse['instructor'].toString(),
                  individualCourse['price'].toString(),
                  individualCourse['date'].toString(),
                  individualCourse['channelName'].toString(),
                  size,
                );
              }
            });
          }
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 25.0),
          child: ListView(
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              children: tilesList),
        );
      },
    );
  }
}
