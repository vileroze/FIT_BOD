import 'dart:async';
import 'package:fitness_app/extra/color.dart';
import 'package:fitness_app/main.dart';
import 'package:fitness_app/screens/client/settings/profile_setting.dart';
import 'package:fitness_app/screens/trainer/profile/addClass/add_class.dart';
import 'package:fitness_app/screens/trainer/profile/classes/class.dart';
import 'package:fitness_app/screens/trainer/profile/clientss/client.dart';
import 'package:fitness_app/services/auth.dart';
import 'package:recase/recase.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileTrainer extends StatefulWidget {
  @override
  State<ProfileTrainer> createState() => _ProfileTrainerState();
}

class _ProfileTrainerState extends State<ProfileTrainer> {
  final _database = FirebaseDatabase.instance.ref();
  String _userName = "Unknown";
  String _userUrl = "";
  String userID = FirebaseAuth.instance.currentUser!.uid;
  String _userInfoPath = "";
  late StreamSubscription _userInfoStream;

  int numClasses = 0;
  bool classPressed = true;
  bool workoutPressed = false;
  bool mealplanPressed = false;
  final FocusNode focusNode = FocusNode();

  final _width = 383.0;
  final Color _accentColor = Color.fromRGBO(231, 88, 20, 1);

  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

  void _activateListeners() {
    bool classPressed = true;
    _userInfoPath = "userDetails/" + userID.trim() + "/";

    _userInfoStream =
        _database.child(_userInfoPath.trim()).onValue.listen((event) {
      final data = Map<String, dynamic>.from(
          event.snapshot.value as Map<dynamic, dynamic>);

      final uName = data['userName'] as String;
      final uUrl = data['profileImgUrl'] as String;
      final totalCourse = data['coursesTaken'] as int;

      setState(() {
        _userName = uName;
        _userUrl = uUrl;
        numClasses = totalCourse;
        Clients();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ScrollController _controller = ScrollController();

    void _animateToIndex(int index) {
      _controller.animateTo(
        index * _width,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.deepOrange[50],
      appBar: AppBar(
        title: Text(
          'TRAINER PROFILE',
          style: TextStyle(
            fontSize: size.width / 30,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
            letterSpacing: 2.0,
            color: _accentColor,
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
                          height: size.height / 7.5,
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
                                  style: TextStyle(fontSize: size.width / 25),
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
        physics: NeverScrollableScrollPhysics(),
        child: IntrinsicHeight(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 25, 0, 0),
                        child: Text(
                          _userName.titleCase,
                          style: TextStyle(
                            fontSize: size.width / 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                            letterSpacing: 1.0,
                            color: _accentColor,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                        child: Text(
                          '$numClasses Total Classes',
                          style: TextStyle(
                            // fontSize: 17.0,
                            fontSize: size.width / 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                            letterSpacing: 1.0,
                            color: _accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: CircleAvatar(
                      backgroundImage: (_userUrl == '')
                          ? AssetImage('assets/profile/random_profile.jpg')
                              as ImageProvider
                          : NetworkImage(_userUrl),
                      radius: size.width / 7,
                      backgroundColor: Colors.deepOrange[500],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Focus(
                      child: TextButton(
                        autofocus: true,
                        focusNode: focusNode,
                        onPressed: () {
                          _animateToIndex(0);
                          setState(() {
                            classPressed = true;
                            workoutPressed = false;
                            mealplanPressed = false;
                          });
                        },
                        child: Text(
                          "CLASSES",
                          style: TextStyle(
                            letterSpacing: 1,
                            fontSize: size.width / 32,
                            color: classPressed
                                ? _accentColor
                                : Color.fromRGBO(231, 88, 20, 0.5),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _animateToIndex(1);
                        setState(() {
                          setState(() {
                            classPressed = false;
                            workoutPressed = true;
                            mealplanPressed = false;
                          });
                        });
                      },
                      child: Text(
                        "ADD CLASS",
                        style: TextStyle(
                          letterSpacing: 1,
                          fontSize: size.width / 32,
                          color: workoutPressed
                              ? _accentColor
                              : Color.fromRGBO(231, 88, 20, 0.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _animateToIndex(3);
                        setState(() {
                          workoutPressed = false;
                          classPressed = false;
                          mealplanPressed = true;
                        });
                      },
                      child: Text(
                        "CLIENTS",
                        style: TextStyle(
                          letterSpacing: 1,
                          fontSize: size.width / 32,
                          color: mealplanPressed
                              ? _accentColor
                              : Color.fromRGBO(231, 88, 20, 0.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: PageScrollPhysics(),
                controller: _controller,
                child: Row(
                  children: <Widget>[
                    Container(
                      // height: size.height / 1.745,
                      height: size.height / 1.7,
                      width: size.width,
                      child: Classes(),
                    ),
                    Container(
                      height: size.height / 1.7,
                      width: size.width,
                      child: AddCLass(),
                    ),
                    Container(
                      height: size.height / 1.7,
                      width: size.width,
                      child: Clients(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton: Container(
      //   // color: Colors.black,
      //   constraints: BoxConstraints(
      //     maxHeight: size.height / 2,
      //   ),
      //   child: Column(
      //     children: <Widget>[
      //       Padding(
      //         padding: const EdgeInsets.only(bottom: 10.0),
      //         child: FloatingActionButton(
      //           heroTag: 'updateProfile',
      //           backgroundColor: Color.fromRGBO(231, 88, 20, 0.6),
      //           onPressed: () {
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(builder: (context) => ProfileSettings()),
      //             );
      //           },
      //           child: Icon(Icons.account_circle),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  @override
  void deactivate() {
    _userInfoStream.cancel();
    super.deactivate();
  }
}
