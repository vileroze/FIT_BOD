import 'package:fitness_app/extra/color.dart';
import 'package:fitness_app/main.dart';
import 'package:fitness_app/screens/admin/allClients/all_client_card.dart';
import 'package:fitness_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class AllClients extends StatefulWidget {
  const AllClients({Key? key}) : super(key: key);

  @override
  State<AllClients> createState() => _AllClientsState();
}

class _AllClientsState extends State<AllClients> {
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
    return Scaffold(
      backgroundColor: Colors.deepOrange[50],
      appBar: AppBar(
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
      body: StreamBuilder(
          stream: _database.child('userDetails').onValue,
          builder: (context, snapshot) {
            final clientCards = <AllClientCardItem>[];
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

                  if (individualDetail['userType'].toString() == 'Client') {
                    final citem = AllClientCardItem(
                      cKey: clientID,
                      clientName: individualDetail['userName'],
                      clientImgUrl: individualDetail['profileImgUrl'],
                      clientEmail: individualDetail['email'],
                      clientPhone: individualDetail['phoneNumber'].toString(),
                      coursesTaken: individualDetail['coursesTaken'],
                    );
                    clientCards.add(citem);
                  }
                });
              }
            }

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: size.height / 20, left: size.width / 20),
                  child: Text(
                    'ALL CLIENTS',
                    style: GoogleFonts.anton(
                      fontSize: size.width / 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                      color: Extra.accentColor,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: size.height / 20, left: 20, right: 20),
                  height: 210.0,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: clientCards,
                  ),
                ),
              ],
            );
          }),
    );
  }
}
