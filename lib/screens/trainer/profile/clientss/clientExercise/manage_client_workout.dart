import 'dart:async';
import 'package:fitness_app/extra/color.dart';
import 'package:fitness_app/screens/trainer/profile/clientss/clientExercise/add_workout.dart';
import 'package:fitness_app/screens/trainer/profile/clientss/clientExercise/view_client_workout.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';

class ManageClientWorkout extends StatefulWidget {
  String ClientId;
  ManageClientWorkout({Key? key, required this.ClientId}) : super(key: key);

  @override
  State<ManageClientWorkout> createState() => _ManageClientWorkoutState();
}

class _ManageClientWorkoutState extends State<ManageClientWorkout> {
  final _database = FirebaseDatabase.instance.ref();
  // late StreamSubscription userDetailRef;

  String clientName = 'Hello';
  String age = 'N/A';
  String weight = 'N/A';
  String height = 'N/A';

  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

  void _activateListeners() {
    _database.child('/userDetails/' + widget.ClientId).onValue.listen((event) {
      if (event.snapshot.value != null) {
        final userDetails = Map<dynamic, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>);

        final uclientName = userDetails['userName'].toString();
        final uage = userDetails['age'].toString();
        final uweight = userDetails['weight'].toString();
        final uheight = userDetails['height'].toString();

        setState(() {
          clientName = uclientName;
          age = uage;
          weight = uweight;
          height = uheight;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.deepOrange[50],
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Extra.accentColor, //change your color here
          ),
          title: Column(
            children: [
              Text(
                'CLIENT WORKOUT',
                style: TextStyle(
                  fontSize: size.width / 27,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                  letterSpacing: 2.0,
                  color: Extra.accentColor,
                ),
              ),
              Text(
                clientName.toUpperCase(),
                style: GoogleFonts.anton(
                  fontSize: size.width / 25,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  color: Extra.accentColor,
                ),
              ),
              Text(
                'Age: $age yo,  Height: $height cm,  Weight: $weight pounds',
                style: GoogleFonts.anton(
                  fontSize: size.width / 30,
                  letterSpacing: 1,
                  color: Extra.accentColor,
                ),
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: Colors.deepOrange[50],
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 0.0, top: 0.0),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Container(
                  //   margin: EdgeInsets.only(
                  //     top: 20,
                  //   ),
                  //   child: Align(
                  //     alignment: Alignment.center,
                  //     child: Text(
                  //       clientName.toUpperCase(),
                  //       style: GoogleFonts.anton(
                  //         fontSize: size.width / 15,
                  //         fontWeight: FontWeight.bold,
                  //         letterSpacing: 3,
                  //         color: Extra.accentColor,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 40,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Add Workout',
                        style: GoogleFonts.anton(
                          fontSize: size.width / 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                          color: Extra.accentColor,
                        ),
                      ),
                    ),
                  ),
                  AddWorkout(cKey: widget.ClientId),
                  Container(
                    margin: EdgeInsets.only(
                      top: 40,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'WORKOUTS',
                        style: GoogleFonts.anton(
                          fontSize: size.width / 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                          color: Extra.accentColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(26),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'EXERCISE',
                          style: TextStyle(
                              color: Extra.accentColor,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 55,
                        ),
                        Text(
                          'SETS',
                          style: TextStyle(
                              color: Extra.accentColor,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Text(
                          'REPS',
                          style: TextStyle(
                              color: Extra.accentColor,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Text(
                          'DEL',
                          style: TextStyle(
                              color: Extra.accentColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  WorkoutViewer(cKey: widget.ClientId),

                  // Container(
                  //   margin: EdgeInsets.all(15),
                  //   padding: EdgeInsets.all(15),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.all(
                  //       Radius.circular(15),
                  //     ),
                  //     border: Border.all(color: Colors.white),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.black12,
                  //         offset: Offset(2, 2),
                  //         spreadRadius: 2,
                  //         blurRadius: 1,
                  //       ),
                  //     ],
                  //   ),
                  //   child: CircleAvatar(
                  //     backgroundImage: (imgUrl == '')
                  //         ? AssetImage('assets/profile/random_profile.jpg')
                  //             as ImageProvider
                  //         : NetworkImage(imgUrl),
                  //     radius: size.width / 5,
                  //     backgroundColor: Colors.deepOrange[500],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ));
  }

  @override
  void deactivate() {
    // userDetailRef.cancel();
    super.deactivate();
  }
}
