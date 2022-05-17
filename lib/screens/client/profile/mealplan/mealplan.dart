import 'package:fitness_app/screens/client/profile/mealplan/mealplan_builder.dart';
import 'package:flutter/material.dart';

class Mealplan extends StatelessWidget {
  const Mealplan({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size.width / 20),
          boxShadow: const [
            BoxShadow(
              //color: Color.fromARGB(255, 240, 101, 96),
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
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(size.width / 20),
              topLeft: Radius.circular(size.width / 20),
            ),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 20, 15, 5),
                child: ListView(
                  children: [
                    Container(
                      height: size.height / 7,
                      child: Image.asset('assets/line_art/mealplan.png'),
                    ),
                    Table(
                      columnWidths: const <int, TableColumnWidth>{
                        0: FlexColumnWidth(),
                        1: FlexColumnWidth(),
                      },
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                height: size.height / 20,
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(229, 128, 40, 1),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                child: Align(
                                  child: Text(
                                    'MEAL',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.width / 25,
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
                                  color: Color.fromRGBO(252, 197, 63, 1),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                child: Align(
                                  child: Text(
                                    'CONTENTS',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.width / 25,
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
                    MealPlanBuilder(),
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
