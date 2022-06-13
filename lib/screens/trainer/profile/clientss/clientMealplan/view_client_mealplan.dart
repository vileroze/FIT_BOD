import 'package:fitness_app/extra/color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:recase/recase.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MealplanViewer extends StatefulWidget {
  String cKey;
  MealplanViewer({Key? key, required this.cKey}) : super(key: key);

  @override
  State<MealplanViewer> createState() => _MealplanViewerState();
}

class _MealplanViewerState extends State<MealplanViewer> {
  final _database = FirebaseDatabase.instance.ref();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Row> tableRows = [];
    return StreamBuilder(
        stream: _database.child('mealplans/' + widget.cKey).onValue,
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
                  final mealplanKey = key.toString();
                  final nextMeal = Map<String, dynamic>.from(value);
                  tableRows.add(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            width: 110,
                            // margin: EdgeInsets.only(left: 5.0),
                            constraints: BoxConstraints(
                              minHeight: size.height / 11,
                              minWidth: size.width / 20,
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
                                  nextMeal['name'].toString().sentenceCase,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: size.width / 27,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            margin: EdgeInsets.only(left: 5.0),
                            constraints: BoxConstraints(
                              maxWidth: size.width / 2.5,
                              minHeight: size.height / 11,
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
                                  nextMeal['content'].toString().sentenceCase,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: size.width / 27,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            // width: 55,
                            margin: EdgeInsets.only(left: 5.0),
                            constraints: BoxConstraints(
                              minHeight: size.width / 6,
                              minWidth: size.width / 27,
                            ),
                            height: 55,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Extra.accentColor,
                                  blurRadius: 4,
                                  //offset: Offset(1, 1), // Shadow position
                                ),
                              ],
                              color: Extra.accentColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                _database
                                    .child('mealplans')
                                    .child(widget.cKey.toString())
                                    .child(mealplanKey.trim())
                                    .remove()
                                    .then((value) {
                                  Fluttertoast.showToast(
                                      msg: "Mealplan Removed!", // message
                                      toastLength: Toast.LENGTH_SHORT, // length
                                      gravity: ToastGravity.CENTER, // location
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Extra.accentColor,
                                      textColor: Colors.white,
                                      fontSize: 16.0 // duration
                                      );
                                  print('New Mealplan has been added');
                                }).catchError(
                                  (error) => print(
                                      '!!!!!!! Error while adding new Mealplan: $error !!!!!!!'),
                                );
                                setState(() {});
                              },
                              child: Text(
                                'X',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.width / 20,
                                    fontWeight: FontWeight.w800),
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
            padding: EdgeInsets.only(left: 10, right: 0),
            height: size.height / 3,
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: tableRows,
            ),
          );
        });
  }
}
