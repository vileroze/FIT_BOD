import 'package:fitness_app/screens/client/profile/workout/workout_builder.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Workout extends StatefulWidget {
  const Workout({Key? key}) : super(key: key);

  @override
  State<Workout> createState() => _WorkoutState();
}

class _WorkoutState extends State<Workout> {
  final _database = FirebaseDatabase.instance.ref();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double tableRowHwading = size.width / 30;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 7,
              offset: Offset(0, 2), // Shadow position
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 5),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Container(
                  height: size.height / 7,
                  child: Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/fitnessapp-292ab.appspot.com/o/backgroundImages%2FlineArt%2Fworkout.png?alt=media&token=146794a1-e1d3-4d43-8245-0fe4eab64ac9'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        width: size.width / 2.6,
                        height: size.height / 20,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(252, 197, 63, 1),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Align(
                          child: Text(
                            'EXERCISE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: tableRowHwading,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        width: size.width / 7,
                        height: size.height / 20,
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(2527, 63, 100, 1),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        child: Align(
                          child: Text(
                            'SETS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: tableRowHwading,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        width: size.width / 7,
                        height: size.height / 20,
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(2, 159, 177, 1),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        child: Align(
                          child: Text(
                            'REPS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: tableRowHwading,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                WorkoutBuilder(),
              ],
            ),
          ),
        ),
        //   ),
        // ),
      ),
    );
  }
}
