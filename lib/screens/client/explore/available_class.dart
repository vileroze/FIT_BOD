import 'dart:convert';

import 'package:fitness_app/screens/client/explore/explore_helper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AvailableClassList extends StatefulWidget {
  String categoryFilter;
  String dateFilter;
  AvailableClassList(
      {Key? key, required this.categoryFilter, required this.dateFilter})
      : super(key: key);

  @override
  State<AvailableClassList> createState() => _AvailableClassListState();
}

class _AvailableClassListState extends State<AvailableClassList> {
  final _database = FirebaseDatabase.instance.ref();
  final Color _accentColor = Color.fromRGBO(231, 88, 20, 1);

  bool booked = false;
  final helperClass = ExploreHelper();

  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(now);

  late AndroidNotificationChannel channel;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    loadFCM();
    listenerFCM();
    getToken();
    FirebaseMessaging.instance.subscribeToTopic('Bookings');
  }

  void sendPushMessage(String className, String token) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAX7dwv1s:APA91bETeXgTdwF_6jF0C0k8eLxh_lR7F79mX_PGI-Tc2i2ayHbXkAOQcdocGew9iUKOoxZjhobw5ORYarkwKiY24eGp8oTrG1mWEDQNLrGJSBBDrYDz6VlIHMNt93VSCfeVer3Q4C7b',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'Someone just booked your  \'' +
                  className +
                  '\' class, open the app to see your clients !!!',
              'title': 'CLASS BOOKING!!'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }

  void getToken() async {
    await FirebaseMessaging.instance
        .getToken()
        .then((token) => print("++++++++++++   " + token.toString()));
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  void listenerFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final DateTime currentDate = DateTime.now();
    final TextTheme textTheme = Theme.of(context).textTheme;
    final tilesList = <ListTile>[];
    int numClass = 0;

    if (widget.dateFilter == '') {
      widget.dateFilter = formatted;
    }

    return StreamBuilder(
      stream: _database.child('classes').onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            final allClasses = Map<dynamic, dynamic>.from(
                ((snapshot.data! as DatabaseEvent).snapshot.value ?? {})
                    as Map<dynamic, dynamic>);

            allClasses.forEach((key, value) {
              final instructorId = key.toString().trim();
              final individualClass = Map<String, dynamic>.from(value);

              individualClass.forEach((key, value) {
                final lastClass = Map<String, dynamic>.from(value);
                print(
                  'tttttttttttttttttttttttttttttttttttttttt  ' +
                      lastClass['FCMToken'].toString(),
                );
                if (lastClass['verified'].toString() == 'true') {
                  if (widget.categoryFilter != '' &&
                      widget.categoryFilter != '') {
                    if (lastClass['category'].toString().toLowerCase() ==
                            widget.categoryFilter.toLowerCase() &&
                        lastClass['date'].toString() == widget.dateFilter) {
                      numClass++;
                      helperClass.addTilesToList(
                        tilesList,
                        lastClass['startTime'].toString(),
                        lastClass['duration'].toString(),
                        lastClass['category'].toString(),
                        lastClass['name'].toString(),
                        lastClass['instructor'].toString(),
                        lastClass['price'].toString(),
                        lastClass['date'].toString(),
                        instructorId.toString(),
                        lastClass['channelName'].toString(),
                        lastClass['experience'].toString(),
                        lastClass['FCMToken'].toString(),
                        context,
                        size,
                        sendPushMessage,
                      );
                    }
                  } else if (widget.categoryFilter != '') {
                    if (lastClass['category'].toString().toLowerCase() ==
                        widget.categoryFilter.toLowerCase()) {
                      numClass++;
                      helperClass.addTilesToList(
                        tilesList,
                        lastClass['startTime'].toString(),
                        lastClass['duration'].toString(),
                        lastClass['category'].toString(),
                        lastClass['name'].toString(),
                        lastClass['instructor'].toString(),
                        lastClass['price'].toString(),
                        lastClass['date'].toString(),
                        instructorId.toString(),
                        lastClass['channelName'].toString(),
                        lastClass['experience'].toString(),
                        lastClass['FCMToken'].toString(),
                        context,
                        size,
                        sendPushMessage,
                      );
                    }
                  } else if (widget.dateFilter != '') {
                    if (lastClass['date'].toString() == widget.dateFilter) {
                      numClass++;
                      helperClass.addTilesToList(
                        tilesList,
                        lastClass['startTime'].toString(),
                        lastClass['duration'].toString(),
                        lastClass['category'].toString(),
                        lastClass['name'].toString(),
                        lastClass['instructor'].toString(),
                        lastClass['price'].toString(),
                        lastClass['date'].toString(),
                        instructorId.toString(),
                        lastClass['channelName'].toString(),
                        lastClass['experience'].toString(),
                        lastClass['FCMToken'].toString(),
                        context,
                        size,
                        sendPushMessage,
                      );
                    }
                  } else {
                    // numClass++;
                    helperClass.addTilesToList(
                      tilesList,
                      lastClass['startTime'].toString(),
                      lastClass['duration'].toString(),
                      lastClass['category'].toString(),
                      lastClass['name'].toString(),
                      lastClass['instructor'].toString(),
                      lastClass['price'].toString(),
                      lastClass['date'].toString(),
                      instructorId.toString(),
                      lastClass['channelName'].toString(),
                      lastClass['experience'].toString(),
                      lastClass['FCMToken'].toString(),
                      context,
                      size,
                      sendPushMessage,
                    );
                  }
                }
              });
            });
            if (numClass == 0) {
              Fluttertoast.showToast(
                  msg: "No classes found!", // message
                  toastLength: Toast.LENGTH_SHORT, // length
                  gravity: ToastGravity.CENTER, // location
                  timeInSecForIosWeb: 1,
                  backgroundColor: _accentColor,
                  textColor: Colors.white,
                  fontSize: 16.0 // duration
                  );
            }
          }
        }
        return ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: tilesList);
      },
    );
  }
}
