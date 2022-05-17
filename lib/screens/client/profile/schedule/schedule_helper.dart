import 'package:fitness_app/screens/client/settings/alarms.dart';
import 'package:fitness_app/screens/communication/video_call.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:recase/recase.dart';
import 'package:intl/intl.dart';

class ScheduleHelper {
  final Color _accentColor = Color.fromRGBO(231, 88, 20, 1);
  final _database = FirebaseDatabase.instance.ref();

  void addTilesToList(
      List<ListTile> tileList,
      String startTime,
      String duration,
      String category,
      String name,
      String instructor,
      String price,
      String date,
      String channelName,
      Size size) {
    DateTime courseDate = DateTime.parse(date);
    String courseDayName = DateFormat('EEEE').format(courseDate);
    String courseDay = DateFormat('d').format(courseDate);
    String courseMonth = DateFormat('MMM').format(courseDate);

    tileList.add(
      ListTile(
        title: Container(
          margin:
              EdgeInsets.only(bottom: size.height / 200, top: size.height / 90),
          child: Row(
            children: <Widget>[
              Text(
                courseDayName.titleCase +
                    ',  ' +
                    courseMonth.titleCase +
                    ' ' +
                    courseDay.titleCase,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontWeight: FontWeight.bold,
                  fontSize: size.width / 28,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                  child: Divider(
                    color: Colors.grey[500],
                    height: 3.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: size.height / 9.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      startTime,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: size.width / 25,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      '(' + duration + 'min)',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: size.width / 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: size.width / 15),
            Container(
              width: size.width / 2.1,
              height: size.height / 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Text(
                      category.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: size.width / 28,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: size.width / 22,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Text(
                      'w/ ' + instructor,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: size.width / 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: size.height / 9.5,
              child: Column(
                children: [
                  Container(
                    child: PopupMenuButton<int>(
                      icon: Icon(Icons.more_horiz),
                      //onSelected: (item) => onSelected(context, item),
                      itemBuilder: (context) => [
                        PopupMenuItem<int>(
                          value: 0,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VideoCall(
                                    channelName: channelName,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'JOIN CLASS',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        PopupMenuDivider(),
                        PopupMenuItem<int>(
                          value: 0,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Alarms()),
                              );
                            },
                            child: Text(
                              'SET ALARM',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Text(
                      'BOOKED',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: size.width / 30,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
