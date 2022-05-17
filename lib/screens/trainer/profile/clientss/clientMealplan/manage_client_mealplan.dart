import 'package:fitness_app/extra/color.dart';
import 'package:fitness_app/screens/trainer/profile/clientss/clientMealplan/add_mealplan.dart';
import 'package:fitness_app/screens/trainer/profile/clientss/clientMealplan/view_client_mealplan.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';

class ManageClientMealplan extends StatefulWidget {
  String ClientId;
  ManageClientMealplan({Key? key, required this.ClientId}) : super(key: key);

  @override
  State<ManageClientMealplan> createState() => _ManageClientMealplanState();
}

class _ManageClientMealplanState extends State<ManageClientMealplan> {
  final _database = FirebaseDatabase.instance.ref();
  // late StreamSubscription userDetailRef;

  String clientName = 'Hello';

  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

  void _activateListeners() {
    _database
        .child('/userDetails/' + widget.ClientId + '/userName')
        .onValue
        .listen((event) {
      final String uname = event.snapshot.value as String;
      setState(() {
        clientName = uname;
      });
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
                'CLIENT MEALPLAN',
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
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 40,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Add Mealplan',
                        style: GoogleFonts.anton(
                          fontSize: size.width / 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                          color: Extra.accentColor,
                        ),
                      ),
                    ),
                  ),
                  AddMealplan(cKey: widget.ClientId),
                  Container(
                    margin: EdgeInsets.only(
                      top: 40,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'MEALPLANS',
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
                          width: size.width / 17,
                        ),
                        Text(
                          'MEAL',
                          style: TextStyle(
                              color: Extra.accentColor,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: size.width / 4.5,
                        ),
                        Text(
                          'CONTENTS',
                          style: TextStyle(
                              color: Extra.accentColor,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: size.width / 5,
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
                  MealplanViewer(cKey: widget.ClientId),
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
