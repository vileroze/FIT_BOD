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
        child: DraggableScrollableSheet(
          initialChildSize: 1,
          maxChildSize: 1,
          minChildSize: 1,
          builder: (context, controller) => ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 5),
                child: ListView(
                  children: [
                    Container(
                      height: size.height / 7,
                      child: Image.asset('assets/line_art/workout.png'),
                    ),
                    Table(
                      columnWidths: <int, TableColumnWidth>{
                        0: FixedColumnWidth(size.width / 2.3),
                        1: FlexColumnWidth(),
                        2: FlexColumnWidth(),
                      },
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: <TableRow>[
                        TableRow(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
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
                      ],
                    ),
                    WorkoutBuilder(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// void onSelected(BuildContext context, int item) {
//   switch (item) {
//     case 0:
//       Navigator.of(context).push(
//         MaterialPageRoute(builder: (context) => Wrapper()),
//       );
//       break;
//     default:
//   }
// }
