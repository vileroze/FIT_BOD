import 'package:fitness_app/screens/client/explore/explore_helper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

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
  // int numClass = 0;

  bool booked = false;
  final helperClass = ExploreHelper();

  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(now);

  @override
  void initState() {
    super.initState();
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
                        context,
                        size,
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
                        context,
                        size,
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
                        context,
                        size,
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
                      context,
                      size,
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
