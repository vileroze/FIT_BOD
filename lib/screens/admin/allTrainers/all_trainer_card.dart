import 'dart:async';

import 'package:fitness_app/extra/color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:recase/recase.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AllTrainerCardItem extends StatefulWidget {
  String cKey;
  String trainerName;
  String trainerImgUrl;
  String trainerEmail;
  String trainerPhone;
  int coursesTaken;
  AllTrainerCardItem({
    Key? key,
    required this.cKey,
    required this.trainerName,
    required this.trainerImgUrl,
    required this.trainerEmail,
    required this.trainerPhone,
    required this.coursesTaken,
  }) : super(key: key);

  @override
  State<AllTrainerCardItem> createState() => _AllTrainerCardItemState();
}

class _AllTrainerCardItemState extends State<AllTrainerCardItem> {
  final _database = FirebaseDatabase.instance.ref();
  late StreamSubscription _userVerifyStream;
  final Uri _url = Uri.parse(
      'https://firebasestorage.googleapis.com/v0/b/fitnessapp-292ab.appspot.com/o/trainerDocuments%2Fccmc_form.pdf?alt=media&token=d4ed1fa2-6cef-4fcb-a6e5-6524c8f228e6');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final detailFontSize = size.width / 25;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        leading: Container(
          child: CircleAvatar(
            radius: size.width / 15,
            backgroundImage: NetworkImage(widget.trainerImgUrl),
          ),
        ),
        title: Text(
          widget.trainerName.toString().titleCase,
          style: TextStyle(
              fontSize: size.width / 20,
              fontWeight: FontWeight.bold,
              color: Extra.accentColor),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.open_in_new,
            color: Extra.accentColor,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Color.fromARGB(255, 155, 69, 29),
                    insetPadding: EdgeInsets.only(
                        bottom: 100, top: 170, right: 30, left: 30),
                    content: Container(
                      // color: Extra.accentColor,
                      height: size.height / 3,
                      width: size.width,
                      child: Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: <Widget>[
                              Positioned(
                                top: -100,
                                child: CircleAvatar(
                                  radius: size.width / 5,
                                  backgroundImage:
                                      NetworkImage(widget.trainerImgUrl),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 50),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: Text(
                                        'Name : ' +
                                            widget.trainerName.titleCase,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: detailFontSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.email_rounded,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            '  ' + widget.trainerEmail,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: detailFontSize,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.local_phone_rounded,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            '  ' + widget.trainerPhone,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: detailFontSize,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white)),
                                          margin: EdgeInsets.only(top: 20),
                                          child: TextButton(
                                            onPressed: () {
                                              _database
                                                  .child('userDetails')
                                                  .child(widget.cKey)
                                                  .update({'verified': 'true'});

                                              _userVerifyStream = _database
                                                  .child('classes')
                                                  .child(widget.cKey)
                                                  .onValue
                                                  .listen((event) {
                                                // print(event.snapshot.value);
                                                final ic =
                                                    Map<dynamic, dynamic>.from(
                                                        event.snapshot.value
                                                            as Map<dynamic,
                                                                dynamic>);

                                                ic.forEach((key, value) {
                                                  print('gggggggg ' +
                                                      key.toString());
                                                  final ind =
                                                      Map<String, dynamic>.from(
                                                          value);
                                                  print(ind['verified']);

                                                  _database
                                                      .child('classes')
                                                      .child(widget.cKey)
                                                      .child(key.toString())
                                                      .update(
                                                          {'verified': 'true'});
                                                });
                                                _userVerifyStream.cancel();
                                              });

                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Trainer is now verified!", // message
                                                  toastLength: Toast
                                                      .LENGTH_SHORT, // length
                                                  gravity: ToastGravity
                                                      .CENTER, // location
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor:
                                                      Extra.accentColor,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0 // duration
                                                  );
                                            },
                                            child: Text(
                                              'VERIFY',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white)),
                                          margin: EdgeInsets.only(top: 20),
                                          child: TextButton(
                                            onPressed: () {
                                              _database
                                                  .child('userDetails')
                                                  .child(widget.cKey)
                                                  .update(
                                                      {'verified': 'false'});

                                              _userVerifyStream = _database
                                                  .child('classes')
                                                  .child(widget.cKey)
                                                  .onValue
                                                  .listen((event) {
                                                // print(event.snapshot.value);
                                                final ic =
                                                    Map<dynamic, dynamic>.from(
                                                        event.snapshot.value
                                                            as Map<dynamic,
                                                                dynamic>);

                                                ic.forEach((key, value) {
                                                  print('gggggggg ' +
                                                      key.toString());
                                                  final ind =
                                                      Map<String, dynamic>.from(
                                                          value);
                                                  print(ind['verified']);

                                                  _database
                                                      .child('classes')
                                                      .child(widget.cKey)
                                                      .child(key.toString())
                                                      .update({
                                                    'verified': 'false'
                                                  });
                                                });
                                                _userVerifyStream.cancel();
                                              });

                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Trainer is now disabled!", // message
                                                  toastLength: Toast
                                                      .LENGTH_SHORT, // length
                                                  gravity: ToastGravity
                                                      .CENTER, // location
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor:
                                                      Extra.accentColor,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0 // duration
                                                  );
                                            },
                                            child: Text(
                                              'DISABLE',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }

  _launchURL() async {
    if (await canLaunchUrl(_url)) {
      await _launchURL();
    } else {
      throw 'Could not launch $_url';
    }
  }
}
