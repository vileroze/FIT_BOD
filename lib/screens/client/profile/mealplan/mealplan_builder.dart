import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recase/recase.dart';

class MealPlanBuilder extends StatefulWidget {
  const MealPlanBuilder({Key? key}) : super(key: key);

  @override
  State<MealPlanBuilder> createState() => _MealPlanBuilderState();
}

class _MealPlanBuilderState extends State<MealPlanBuilder> {
  final _database = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Row> tableRows = [];
    return StreamBuilder(
        stream: _database
            .child('mealplans/' + FirebaseAuth.instance.currentUser!.uid)
            .onValue,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              final allMeals = Map<String, dynamic>.from(
                  ((snapshot.data as DatabaseEvent).snapshot.value ?? {})
                      as Map<dynamic, dynamic>);
              allMeals.forEach((key, value) {
                final nextMeal = Map<String, dynamic>.from(value);
                tableRows.add(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          // margin: EdgeInsets.only(left: 5.0),
                          constraints: BoxConstraints(
                            minHeight: size.height / 11,
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
                                nextMeal['name'].toString().sentenceCase,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: size.width / 28,
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
                                  fontSize: size.width / 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
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
