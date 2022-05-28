import 'dart:async';

import 'package:fitness_app/extra/color.dart';
import 'package:fitness_app/main.dart';
import 'package:fitness_app/screens/admin/allTrainers/all_trainer_card.dart';
import 'package:fitness_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class AllTrainers extends StatefulWidget {
  const AllTrainers({Key? key}) : super(key: key);

  @override
  State<AllTrainers> createState() => _AllTrainersState();
}

class _AllTrainersState extends State<AllTrainers> {
  final _database = FirebaseDatabase.instance.ref();
  String profileImg = '';
  String clientName = '';
  List<String> clientIds = [];
  String clientId = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Scaffold(
        backgroundColor: Colors.deepOrange[50],
        appBar: AppBar(
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: Colors.transparent),
          iconTheme: IconThemeData(
            color: Extra.accentColor, //change your color here
          ),
          title: Text(
            'ADMIN',
            style: TextStyle(
              fontSize: size.width / 25,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              letterSpacing: 2.0,
              color: Extra.accentColor,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.deepOrange[50],
          elevation: 0.0,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Container(
                            height: 100,
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Are you sure you want to sign out?',
                                  style: TextStyle(color: Extra.accentColor),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Extra.accentColor),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                  ),
                                  onPressed: () async {
                                    await AuthService(FirebaseAuth.instance)
                                        .signOut();
                                    // await context.re
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) => AuthWrapper(),
                                        ),
                                        (route) => false);
                                  },
                                  child: Text(
                                    'Sign Out',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                },
                icon: Icon(
                  Icons.logout_rounded,
                  color: Colors.deepOrange.shade500,
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: StreamBuilder(
              stream: _database.child('userDetails').onValue,
              builder: (context, snapshot) {
                final clientCards = <AllTrainerCardItem>[];
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    final allPotentailClients = Map<dynamic, dynamic>.from(
                        ((snapshot.data! as DatabaseEvent).snapshot.value ?? {})
                            as Map<dynamic, dynamic>);

                    allPotentailClients.forEach((key, value) {
                      final individualDetail = Map<String, dynamic>.from(value);
                      String clientID = key.toString();

                      final indCourse = Map<String, dynamic>.from(value);

                      if (individualDetail['userType'].toString() ==
                          'Trainer') {
                        final citem = AllTrainerCardItem(
                            cKey: clientID,
                            trainerName: individualDetail['userName'],
                            trainerImgUrl: individualDetail['profileImgUrl'],
                            trainerEmail: individualDetail['email'],
                            trainerPhone:
                                individualDetail['phoneNumber'].toString(),
                            coursesTaken: individualDetail['coursesTaken'],
                            experience: individualDetail['experience']);
                        clientCards.add(citem);
                      }
                    });
                  }
                }

                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      height: size.height / 1.6,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: size.height / 20,
                                left: size.width / 20,
                                bottom: size.height / 30),
                            child: Text(
                              'ALL TRAINERS',
                              style: GoogleFonts.anton(
                                fontSize: size.width / 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3,
                                color: Extra.accentColor,
                              ),
                            ),
                          ),
                          ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: clientCards,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
