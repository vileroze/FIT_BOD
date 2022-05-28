import 'dart:io';

import 'package:fitness_app/extra/color.dart';
import 'package:fitness_app/screens/client/settings/alarms.dart';
import 'package:fitness_app/screens/client/settings/personal_info.dart';
import 'package:fitness_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  File? file;
  TextEditingController hourController = TextEditingController();
  TextEditingController minuteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // final fileName = file != null ? basename(file!.path) : 'No File Selected';

    return Scaffold(
      backgroundColor: Colors.deepOrange[50],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Extra.accentColor, //change your color here
        ),
        title: Text(
          'SETTINGS',
          style: TextStyle(
            fontSize: size.width / 27,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
            letterSpacing: 2.0,
            color: Extra.accentColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrange[50],
        elevation: 2.0,
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
      body: Column(
        children: [
          returnSettingsRow(Icons.alarm_rounded, Alarms(), size, 'alarms'),
          returnSettingsRow(Icons.info_outline_rounded, PersonalInfo(), size,
              'personal info'),
        ],
      ),
    );
  }

  Widget returnSettingsRow(
      IconData icon, Widget widget, Size size, String widgetName) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            //color: Color.fromARGB(255, 240, 101, 96),
            color: Colors.black54,
            blurRadius: 7,
            offset: Offset(0, 2), // Shadow position
          ),
        ],
        // border: Border.all(color: Extra.accentColor)),
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      margin: EdgeInsets.only(top: 30, left: 20, right: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => widget),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 30,
                  color: Extra.accentColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  widgetName.toUpperCase(),
                  style: GoogleFonts.anton(
                    fontSize: 25,
                    color: Extra.accentColor,
                  ),
                ),
              ],
            ),
            Container(
              // padding: EdgeInsets.only(left: size.width / 3),
              child: Icon(
                Icons.keyboard_arrow_right_outlined,
                size: 30,
                color: Extra.accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
