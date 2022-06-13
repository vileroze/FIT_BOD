import 'dart:async';
// import 'dart:math';
// import 'package:esewa_pnp/esewa.dart';
// import 'package:esewa_pnp/esewa_pnp.dart';
import 'package:fitness_app/extra/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recase/recase.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';

// class ExploreHelper extends StatefulWidget {
//   const ExploreHelper({Key? key}) : super(key: key);

//   @override
//   State<ExploreHelper> createState() => _ExploreHelperState();
// }

class ExploreHelper {
  final Color _accentColor = Color.fromRGBO(231, 88, 20, 1);

  final _database = FirebaseDatabase.instance.ref();

  late StreamSubscription _addClassStream;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();

  // }

  void addTilesToList(
      List<ListTile> tileList,
      String startTime,
      String duration,
      String category,
      String name,
      String instructor,
      String price,
      String date,
      String instructorID,
      String channelName,
      String experience,
      String token,
      BuildContext context,
      Size size,
      Function sendNotification) {
    tileList.add(
      ListTile(
        title: Row(
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 10.0, 0.0, 0.0),
              ),
            ),
          ],
        ),
        subtitle: Container(
          padding: EdgeInsets.only(bottom: 5.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      startTime,
                      style: TextStyle(
                          fontSize: size.width / 24,
                          color: Colors.black,
                          // letterSpacing: 1,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 35),
                    child: Container(
                      child: Text(
                        '(' + duration + 'min)',
                        style: GoogleFonts.lato(
                          fontSize: size.width / 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: size.width / 15),
              Container(
                width: size.width / 2.2,
                child: GestureDetector(
                  onTap: () {
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
                                fontWeight: FontWeight.bold,
                                // letterSpacing: 3,
                                color: Extra.accentColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: Container(
                                  margin: EdgeInsets.only(right: 5.0),
                                  child: Icon(Icons.cell_tower,
                                      color: _accentColor, size: 20),
                                ),
                              ),
                              TextSpan(
                                text: category.toUpperCase(),
                                style: GoogleFonts.bebasNeue(
                                  fontSize: 20,
                                  color: Colors.black,
                                  // letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: size.width / 1.5,
                        ),
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Text(
                          name.titleCase,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: size.width / 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Text(
                              'w/ ' + instructor,
                              style: GoogleFonts.lato(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            '| ' + experience + ' yrs',
                            style: GoogleFonts.lato(
                                color: Extra.accentColor,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        
                        sendNotification(name.titleCase, token);
                        _database
                            .child('course/' +
                                FirebaseAuth.instance.currentUser!.uid +
                                '/')
                            .once()
                            .then((event) {
                          int booked = 0;
                          if (event.snapshot.value != null) {
                            final allClass = Map<dynamic, dynamic>.from(
                                event.snapshot.value as Map<dynamic, dynamic>);

                            allClass.forEach((key, value) {
                              final indClass =
                                  Map<dynamic, dynamic>.from(value);
                              if (channelName == indClass['channelName']) {
                                Fluttertoast.showToast(
                                  msg: "Class already Booked!", // message
                                  toastLength: Toast.LENGTH_SHORT, // length
                                  gravity: ToastGravity.TOP, // location
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: _accentColor,
                                  textColor: Colors.white,
                                  fontSize: size.width / 20, // duration
                                );
                                booked++;
                              } else {
                                print('==========================');
                              }
                            });
                          }

                          if (booked == 0) {
                            final newCourse = <String, dynamic>{
                              'name': name,
                              'duration': duration,
                              'instructor': instructor,
                              'category': category,
                              'startTime': startTime,
                              'date': date,
                              'instructorId': instructorID.trim(),
                              'channelName': channelName,
                            };

                            _database
                                .child('course/' +
                                    FirebaseAuth.instance.currentUser!.uid +
                                    '/')
                                .push()
                                .set(newCourse)
                                .then((value) =>
                                    print('NewCourse has been added'))
                                .catchError(
                                  (error) => print(
                                      '!!!!!!! Error while pushing new course: $error !!!!!!!'),
                                );

                            final courseRef = _database
                                .child('userDetails')
                                .child(FirebaseAuth.instance.currentUser!.uid
                                    .toString())
                                .child('coursesTaken');

                            final courseRef2 = _database
                                .child('userDetails')
                                .child(FirebaseAuth.instance.currentUser!.uid
                                    .toString());

                            courseRef.once().then((event) {
                              int coursesTaken = 0;
                              print(event.snapshot.value.toString());

                              coursesTaken =
                                  int.parse(event.snapshot.value.toString());

                              coursesTaken = coursesTaken + 1;

                              courseRef2.update({'coursesTaken': coursesTaken});
                            });

                            _database
                                .child('clientRecomendation/' +
                                    FirebaseAuth.instance.currentUser!.uid +
                                    '/')
                                .set({'preference': category});

                            Fluttertoast.showToast(
                                msg: "Class Booked!", // message
                                toastLength: Toast.LENGTH_SHORT, // length
                                gravity: ToastGravity.TOP, // location
                                timeInSecForIosWeb: 1,
                                backgroundColor: _accentColor,
                                textColor: Colors.white,
                                fontSize: size.width / 20 // duration
                                );
                            sendNotification(name.titleCase, token);
                          }
                        });

                        // _intiPayment(name, channelName, double.parse(price));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        textStyle: TextStyle(
                          fontSize: size.width / 30,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: Text(
                        'BOOK',
                        style: TextStyle(
                            color: Extra.accentColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
