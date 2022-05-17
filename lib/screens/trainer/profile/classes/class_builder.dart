import 'dart:async';
import 'package:fitness_app/extra/button_styles.dart';
import 'package:fitness_app/extra/color.dart';
import 'package:fitness_app/screens/trainer/profile/classes/class_helper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AllClasses extends StatefulWidget {
  const AllClasses({Key? key}) : super(key: key);

  @override
  State<AllClasses> createState() => _AllClassesState();
}

class _AllClassesState extends State<AllClasses> {
  final _database = FirebaseDatabase.instance.ref();

  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  String classesToday = 'today';

  bool booked = false;
  final helperClass = ClassesHelper();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String formatted = formatter.format(now);
    DateTime todayDate = DateFormat("yyyy-MM-dd").parse(formatted);

    final tilesList = <ListTile>[];
    Size size = MediaQuery.of(context).size;
    tilesList.add(ListTile(
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: size.height / 5.5,
                child: Image.asset('assets/line_art/classes.jpg'),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          .child('classes/' + FirebaseAuth.instance.currentUser!.uid + '/')
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
              String classKey = key.toString();
              final individualClass = Map<String, dynamic>.from(value);

              if (classesToday.trim() != 'all') {
                if (classesToday == 'today') {
                  if (formatted == individualClass['date'].toString()) {
                    helperClass.addTilesToList(
                      tilesList,
                      individualClass['startTime'].toString(),
                      individualClass['duration'].toString(),
                      individualClass['category'].toString(),
                      individualClass['name'].toString(),
                      individualClass['instructor'].toString(),
                      individualClass['price'].toString(),
                      individualClass['date'].toString(),
                      classKey,
                      size,
                    );
                  }
                }

                if (classesToday.trim() == 'upcoming') {
                  if (DateFormat("yyyy-MM-dd")
                          .parse(individualClass['date'].toString())
                          .compareTo(todayDate) >
                      0) {
                    helperClass.addTilesToList(
                      tilesList,
                      individualClass['startTime'].toString(),
                      individualClass['duration'].toString(),
                      individualClass['category'].toString(),
                      individualClass['name'].toString(),
                      individualClass['instructor'].toString(),
                      individualClass['price'].toString(),
                      individualClass['date'].toString(),
                      classKey,
                      size,
                    );
                  }
                }
              } else {
                helperClass.addTilesToList(
                  tilesList,
                  individualClass['startTime'].toString(),
                  individualClass['duration'].toString(),
                  individualClass['category'].toString(),
                  individualClass['name'].toString(),
                  individualClass['instructor'].toString(),
                  individualClass['price'].toString(),
                  individualClass['date'].toString(),
                  classKey,
                  size,
                );
              }
            });
          }
        }
        return Container(
          margin: EdgeInsets.only(bottom: 40),
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
