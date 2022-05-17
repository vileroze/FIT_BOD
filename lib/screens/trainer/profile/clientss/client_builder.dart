import 'package:fitness_app/screens/trainer/profile/clientss/card_item.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClientBuilder extends StatefulWidget {
  const ClientBuilder({Key? key}) : super(key: key);

  @override
  State<ClientBuilder> createState() => _ClientBuilderState();
}

class _ClientBuilderState extends State<ClientBuilder> {
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
    return StreamBuilder(
        stream: _database.child('course').onValue,
        builder: (context, snapshot) {
          final clientCards = <CardItem>[];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              final allPotentailClients = Map<dynamic, dynamic>.from(
                  ((snapshot.data! as DatabaseEvent).snapshot.value ?? {})
                      as Map<dynamic, dynamic>);

              allPotentailClients.forEach((key, value) {
                final individualCourse = Map<String, dynamic>.from(value);
                String clientID = key.toString();

                individualCourse.forEach((key, value) {
                  final indCourse = Map<String, dynamic>.from(value);

                  if (indCourse['instructorId'].toString() ==
                      FirebaseAuth.instance.currentUser!.uid) {
                    final citem = CardItem(
                      cKey: clientID,
                      courseName: indCourse['name'].toString(),
                      courseDate: indCourse['date'].toString(),
                      courseTime: indCourse['startTime'].toString(),
                      channelName: indCourse['channelName'].toString(),
                    );
                    clientCards.add(citem);
                  }
                });
              });
            }
          }

          return Container(
            height: size.height / 3.2,
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: clientCards,
            ),
          );
        });
  }
}
