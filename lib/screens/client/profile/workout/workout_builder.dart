import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recase/recase.dart';

class WorkoutBuilder extends StatefulWidget {
  const WorkoutBuilder({Key? key}) : super(key: key);

  @override
  State<WorkoutBuilder> createState() => _WorkoutBuilderState();
}

class _WorkoutBuilderState extends State<WorkoutBuilder> {
  final _database = FirebaseDatabase.instance.ref();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double minHeightWidth = size.height / 11;
    double workoutFont = size.width / 25;
    List<Row> tableRows = [];
    return StreamBuilder(
        stream: _database
            .child('workouts/' + FirebaseAuth.instance.currentUser!.uid)
            .onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              final allMeals = Map<dynamic, dynamic>.from(
                  ((snapshot.data! as DatabaseEvent).snapshot.value ?? {})
                      as Map<dynamic, dynamic>);
              allMeals.forEach(
                (key, value) {
                  final nextWorkout = Map<String, dynamic>.from(value);
                  tableRows.add(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            margin: EdgeInsets.only(left: 0.0),
                            constraints: BoxConstraints(
                              minHeight: minHeightWidth,
                              minWidth: size.width / 2.5,
                            ),
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(252, 197, 63, 1),
                                  blurRadius: 4,
                                  //offset: Offset(1, 1), // Shadow position
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Align(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  nextWorkout['name'].toString().headerCase,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: workoutFont,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            margin: EdgeInsets.only(left: size.width / 40),
                            constraints: BoxConstraints(
                              minHeight: minHeightWidth,
                              minWidth: minHeightWidth,
                            ),
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(2527, 63, 100, 1),
                                  blurRadius: 4,
                                  //offset: Offset(1, 1), // Shadow position
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Align(
                              child: Text(
                                nextWorkout['sets'].toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: workoutFont,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(0),
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            constraints: BoxConstraints(
                              minHeight: minHeightWidth,
                              minWidth: minHeightWidth,
                            ),
                            height: 55,
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(2, 159, 177, 1),
                                  blurRadius: 4,
                                  //offset: Offset(1, 1), // Shadow position
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Align(
                              child: Text(
                                nextWorkout['reps'].toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: workoutFont,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          }

          return Container(
            height: size.height / 3,
            child: ListView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: tableRows,
            ),
          );
        });
  }
}
