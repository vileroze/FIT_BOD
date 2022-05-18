import 'dart:async';
import 'package:fitness_app/extra/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recase/recase.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClassesHelper {
  final Color _accentColor = Color.fromRGBO(231, 88, 20, 1);
  late StreamSubscription _deleteClass;
  final _database = FirebaseDatabase.instance.ref();
  void addTilesToList(
      List<ListTile> tileList,
      String startTime,
      String duration,
      String category,
      String name,
      String instructor,
      String price,
      String date,
      String classKey,
      Size size) {
    DateTime courseDate = DateTime.parse(date);
    String courseDayName = DateFormat('EEEE').format(courseDate);
    String courseDay = DateFormat('d').format(courseDate);
    String courseMonth = DateFormat('MMM').format(courseDate);

    tileList.add(
      ListTile(
        title: Container(
          margin: EdgeInsets.only(bottom: 10, top: 20),
          child: Row(
            children: <Widget>[
              Text(
                courseDayName.titleCase +
                    ',  ' +
                    courseMonth.titleCase +
                    ' ' +
                    courseDay.titleCase,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontWeight: FontWeight.bold,
                  fontSize: size.width / 28,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                  child: Divider(
                    color: Colors.grey[500],
                    height: 3.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: size.height / 9.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      startTime,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: size.width / 25,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      '(' + duration + 'min)',
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: size.width / 28,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: size.width / 15),
            Container(
              width: size.width / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Text(
                      category.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: size.width / 30,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: size.width / 20,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Text(
                      'w/ ' + instructor,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: size.width / 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  child: PopupMenuButton<int>(
                    icon: Icon(Icons.more_horiz),
                    //onSelected: (item) => onSelected(context, item),
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<int>(
                        value: 0,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            textStyle: TextStyle(fontSize: size.width / 30),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                color: Colors.transparent,
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                height: size.height / 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: size.height / 4,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        image: const DecorationImage(
                                          image: NetworkImage(
                                              'https://firebasestorage.googleapis.com/v0/b/fitnessapp-292ab.appspot.com/o/backgroundImages%2FlineArt%2FindClass.png?alt=media&token=db3f8acf-8826-4674-945d-e98e2cc183c2'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Time : ' +
                                          startTime.titleCase +
                                          '\nDuration : ' +
                                          duration.titleCase +
                                          '\nCategory : ' +
                                          category.titleCase +
                                          '\nName : ' +
                                          name.titleCase +
                                          '\nPrice : ' +
                                          price.titleCase +
                                          '\nInstructor : ' +
                                          instructor.titleCase,
                                      // textAlign: TextAlign.center,
                                      style: GoogleFonts.workSans(
                                        fontSize: size.width / 25,
                                        height: 1.5,
                                        // fontWeight: FontWeight.bold,
                                        // letterSpacing: 3,
                                        color: Extra.accentColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                            // Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: Text(
                            'VIEW',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: size.width / 28,
                            ),
                          ),
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem<int>(
                        value: 1,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            textStyle: TextStyle(
                              fontSize: size.width / 28,
                            ),
                          ),
                          onPressed: () {
                            //delte the class
                            _database
                                .child('classes/' +
                                    FirebaseAuth.instance.currentUser!.uid
                                        .toString() +
                                    '/')
                                .child(classKey)
                                .remove()
                                .then(
                                    (value) => print('Class has been removed'))
                                .catchError(
                                  (error) => print(
                                      '!!!!!!! Error while deleting class: $error !!!!!!!'),
                                );

                            //decrease the courses count
                            _deleteClass = _database
                                .child('userDetails')
                                .child(FirebaseAuth.instance.currentUser!.uid
                                    .toString())
                                .child('coursesTaken')
                                .onValue
                                .listen((event) {
                              int coursesTaken = 0;
                              print(event.snapshot.value.toString());

                              coursesTaken =
                                  int.parse(event.snapshot.value.toString());

                              coursesTaken = coursesTaken - 1;
                              _database
                                  .child('userDetails')
                                  .child(FirebaseAuth.instance.currentUser!.uid
                                      .toString())
                                  .update({'coursesTaken': coursesTaken});
                              _deleteClass.cancel();
                            });

                            Fluttertoast.showToast(
                                msg: "Class deleted!", // message
                                toastLength: Toast.LENGTH_SHORT, // length
                                gravity: ToastGravity.CENTER, // location
                                timeInSecForIosWeb: 1,
                                backgroundColor: _accentColor,
                                textColor: Colors.white,
                                fontSize: 16.0 // duration
                                );

                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: Text(
                            'DELETE',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: size.width / 28,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
