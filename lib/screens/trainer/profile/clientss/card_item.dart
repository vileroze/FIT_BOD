import 'package:fitness_app/extra/color.dart';
import 'package:fitness_app/screens/communication/video_call.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/screens/trainer/profile/clientss/clientExercise/manage_client_workout.dart';
import 'package:fitness_app/screens/trainer/profile/clientss/clientMealplan/manage_client_mealplan.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:recase/recase.dart';

class CardItem extends StatefulWidget {
  String cKey;
  String courseName;
  String courseDate;
  String courseTime;
  String channelName;
  CardItem({
    Key? key,
    required this.cKey,
    required this.courseName,
    required this.courseDate,
    required this.courseTime,
    required this.channelName,
  }) : super(key: key);

  @override
  State<CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  final _database = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: _database
          .child('userDetails')
          .child(widget.cKey.toString().trim())
          .onValue,
      builder: (context, snapshot) {
        String uurl = '';
        String uName = '';
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            final userDetails = Map<dynamic, dynamic>.from(
                ((snapshot.data! as DatabaseEvent).snapshot.value ?? {})
                    as Map<dynamic, dynamic>);
            uurl = userDetails['profileImgUrl'];
            uName = userDetails['userName'];
          }
        }
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              radius: size.width / 10,
              backgroundImage: NetworkImage(uurl),
            ),
            title: Text(
              uName.toString().titleCase,
              style: TextStyle(
                fontSize: size.width / 23,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.courseName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.courseDate + ' at',
                  style: TextStyle(
                    fontSize: size.width / 30,
                  ),
                ),
                Text(
                  widget.courseTime,
                  style: TextStyle(
                    fontSize: size.width / 30,
                  ),
                ),
              ],
            ),
            trailing: PopupMenuButton<int>(
              icon: Icon(Icons.more_vert),
              //onSelected: (item) => onSelected(context, item),
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<int>(
                  value: 0,
                  child: TextButton(
                    style: TextButton.styleFrom(),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManageClientWorkout(
                            ClientId: widget.cKey,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'WORKOUT',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: size.width / 30,
                      ),
                    ),
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<int>(
                  value: 1,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(fontSize: size.width / 20),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManageClientMealplan(
                            ClientId: widget.cKey,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'MEALPLAN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: size.width / 30,
                      ),
                    ),
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<int>(
                  value: 1,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(fontSize: 13),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.red[50],
                              content: Container(
                                height: size.height / 4,
                                width: size.width / 3,
                                child: Column(
                                  children: [
                                    Stack(
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        Positioned(
                                          top: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                    blurRadius: 18,
                                                    color: Extra.accentColor,
                                                    spreadRadius: 5)
                                              ],
                                            ),
                                            child: CircleAvatar(
                                              radius: size.width / 7,
                                              backgroundImage:
                                                  NetworkImage(uurl),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 130),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 20, right: 20),
                                                    margin: EdgeInsets.only(
                                                        top: 20),
                                                    child: IconButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    VideoCall(
                                                              channelName: widget
                                                                  .channelName,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      icon: Icon(
                                                        Icons.video_call,
                                                        size: 35,
                                                        color:
                                                            Extra.accentColor,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 20, right: 20),
                                                    margin: EdgeInsets.only(
                                                        top: 20),
                                                    child: IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(
                                                        Icons.message_rounded,
                                                        size: 35,
                                                        color:
                                                            Extra.accentColor,
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
                    child: Text(
                      'CONTACT',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: size.width / 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
