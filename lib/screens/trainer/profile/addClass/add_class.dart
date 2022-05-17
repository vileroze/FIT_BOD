import 'dart:async';
import 'dart:math';

import 'package:fitness_app/extra/color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recase/recase.dart';
import 'package:fluttertoast/fluttertoast.dart';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

class AddCLass extends StatefulWidget {
  const AddCLass({
    Key? key,
  }) : super(key: key);

  @override
  State<AddCLass> createState() => _AddCLassState();
}

class _AddCLassState extends State<AddCLass> {
  final _database = FirebaseDatabase.instance.ref();
  late StreamSubscription _userInfoStream;
  late StreamSubscription _addClass;

  DateTime selectedDate = DateTime.now();
  final TextEditingController classNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String catValue = 'Strength';

  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  String dateReturned = '';
  String timeReturned = '';

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  // late DateTime _selectedDate;
  // late TimeOfDay _selectedTime;

  final timeFormatter = DateFormat.jm();

  //Method for showing the date picker
  void _pickDateDialog() {
    showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Extra.accentColor, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Extra.accentColor, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.red, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialDate: DateTime.now(),
      //which date will display when user open the picker
      firstDate: DateTime.now(),
      //what will be the previous supported year in picker
      lastDate: DateTime.now().add(
        Duration(days: 7),
      ),
    ) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        _selectedDate = pickedDate;
        dateReturned = formatter.format(_selectedDate).toString();
      });
    });
  }

  void _pickTimeDialog() async {
    await showTimePicker(
        context: context,
        initialTime: _selectedTime,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Extra.accentColor, // header background color
                onPrimary: Colors.white, // header text color
                onSurface: Extra.accentColor, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.red, // button text color
                ),
              ),
            ),
            child: child!,
          );
        }).then((pickedTime) {
      //then usually do the future job
      if (pickedTime == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        _selectedTime = pickedTime;
        timeReturned = _selectedTime.format(context);
        // dateReturned = formatter.format(_selectedDate).toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              //color: Color.fromARGB(255, 240, 101, 96),
              color: Colors.black54,
              blurRadius: 7,
              offset: Offset(0, 2), // Shadow position
            ),
          ],
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 1,
          maxChildSize: 1,
          minChildSize: 1,
          builder: (context, controller) => ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
            child: Container(
              //height: size.height,
              color: Colors.white,
              child: Form(
                key: _formKey,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      // physics: NeverScrollableScrollPhysics(),
                      child: Container(
                        // padding: EdgeInsets.only(
                        //     top: MediaQuery.of(context).size.height * 0.2),
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: size.width / 20,
                                    bottom: size.width / 20),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'CREATE A CLASS',
                                    style: GoogleFonts.anton(
                                      fontSize: size.width / 17,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 3,
                                      color: Extra.accentColor,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: size.width / 12,
                                    right: size.width / 12),
                                child: Container(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: size.width / 0.4,
                                        child: TextFormField(
                                          style: const TextStyle(
                                              color: Colors.black),
                                          controller: classNameController,
                                          validator: (value) {
                                            if (value == '') {
                                              return 'Name can\'t be empty';
                                            }
                                          },
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Color.fromRGBO(
                                                255, 255, 255, 0.5),
                                            labelText: 'Class Title',
                                            labelStyle:
                                                TextStyle(color: Colors.black),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Extra.accentColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: size.width / 2.2,
                                            child: Container(
                                              height: 65,
                                              child: InputDecorator(
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Color.fromRGBO(
                                                      255, 255, 255, 0.5),
                                                  labelText: 'Category',
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide(
                                                      color: Extra.accentColor,
                                                    ),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                child: DropdownButton<String>(
                                                  value: catValue,
                                                  isExpanded: true,
                                                  icon: const Icon(
                                                      Icons.arrow_drop_down),
                                                  elevation: 0,
                                                  underline: Container(
                                                    height: 0,
                                                  ),
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      catValue = newValue!;
                                                    });
                                                  },
                                                  items: <String>[
                                                    'Strength',
                                                    'Yoga',
                                                    'Meditation',
                                                    'Barre',
                                                    'Pilates',
                                                  ].map((String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: size.width / 25,
                                          ),
                                          SizedBox(
                                            width: size.width / 3.6,
                                            child: Container(
                                              height: size.width / 6.5,
                                              child: ElevatedButton(
                                                child: Text(
                                                  'ADD DATE',
                                                  style: TextStyle(
                                                      fontSize: size.width / 30,
                                                      color: Extra.accentColor),
                                                ),
                                                onPressed: _pickDateDialog,
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.white,
                                                  side: BorderSide(
                                                      color: Extra.accentColor),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: size.width / 4.3,
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              controller: priceController,
                                              validator: (value) {
                                                if (value?.isEmpty == true) {
                                                  return 'Price can\'t be empty';
                                                }
                                              },
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Color.fromRGBO(
                                                    255, 255, 255, 0.5),
                                                labelText: 'Price',
                                                labelStyle: TextStyle(
                                                    color: Colors.black),
                                                border: OutlineInputBorder(
                                                    // borderRadius: BorderRadius.circular(10),
                                                    ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                    color: Extra.accentColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            width: size.width / 4.3,
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              controller: durationController,
                                              validator: (value) {
                                                if (value?.isEmpty == true) {
                                                  return 'Duration can\'t be empty';
                                                }
                                              },
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Color.fromRGBO(
                                                    255, 255, 255, 0.5),
                                                labelText: 'Duration',
                                                labelStyle: TextStyle(
                                                    color: Colors.black),
                                                border: OutlineInputBorder(
                                                    // borderRadius: BorderRadius.circular(10),
                                                    ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                    color: Extra.accentColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            width: size.width / 4.3,
                                            child: Container(
                                              height: 65,
                                              child: ElevatedButton(
                                                child: Text(
                                                  'TIME',
                                                  style: TextStyle(
                                                      fontSize: size.width / 30,
                                                      color: Extra.accentColor),
                                                ),
                                                onPressed: _pickTimeDialog,
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.white,
                                                    side: BorderSide(
                                                        color:
                                                            Extra.accentColor)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        _selectedDate ==
                                                null //ternary expression to check if date is null
                                            ? 'No date was chosen!'
                                            : 'Picked Date: ${formatter.format(_selectedDate)}',
                                        style: TextStyle(
                                          color: Extra.accentColor,
                                        ),
                                      ),
                                      Text(
                                        _selectedDate ==
                                                null //ternary expression to check if date is null
                                            ? 'No date was chosen!'
                                            : 'Picked Time: ${_selectedTime.format(context)}',
                                        style: TextStyle(
                                          color: Extra.accentColor,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            color: Extra.accentColor,
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                _userInfoStream = _database
                                                    .child('userDetails')
                                                    .child(FirebaseAuth.instance
                                                        .currentUser!.uid
                                                        .toString())
                                                    .onValue
                                                    .listen((event) {
                                                  final uMap = Map<dynamic,
                                                      dynamic>.from(event
                                                          .snapshot.value
                                                      as Map<dynamic, dynamic>);

                                                  print(getRandomString(10));

                                                  final newClass =
                                                      <String, dynamic>{
                                                    'name': classNameController
                                                        .text
                                                        .toString(),
                                                    'duration':
                                                        durationController.text
                                                            .toString(),
                                                    'category':
                                                        catValue.toString(),
                                                    'startTime': timeReturned,
                                                    'price': priceController
                                                        .text
                                                        .toString(),
                                                    'date':
                                                        dateReturned.toString(),
                                                    'instructor':
                                                        uMap['userName']
                                                            .toString()
                                                            .titleCase,
                                                    'verified': uMap['verified']
                                                        .toString(),
                                                    'channelName':
                                                        getRandomString(10)
                                                            .trim(),
                                                  };
                                                  _database
                                                      .child('classes')
                                                      .child(FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid
                                                          .toString())
                                                      .push()
                                                      .set(newClass)
                                                      .then((value) {
                                                    print(
                                                        'NewClass has been added');
                                                  }).catchError(
                                                    (error) => print(
                                                        '!!!!!!! Error while adding new class: $error !!!!!!!'),
                                                  );
                                                  _userInfoStream.cancel();

                                                  _addClass = _database
                                                      .child('userDetails')
                                                      .child(FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid
                                                          .toString())
                                                      .child('coursesTaken')
                                                      .onValue
                                                      .listen((event) {
                                                    int coursesTaken = 0;
                                                    print(event.snapshot.value
                                                        .toString());

                                                    coursesTaken = int.parse(
                                                        event.snapshot.value
                                                            .toString());

                                                    coursesTaken =
                                                        coursesTaken + 1;

                                                    print(
                                                        'hhhhhhhhhhhhhhhhhh---------' +
                                                            coursesTaken
                                                                .toString());

                                                    _database
                                                        .child('userDetails')
                                                        .child(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid
                                                            .toString())
                                                        .update({
                                                      'coursesTaken':
                                                          coursesTaken
                                                    });
                                                    _addClass.cancel();
                                                  });

                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Class Added!", // message
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
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                });
                                                // _addClass.cancel();
                                              } else {
                                                final snackBar = SnackBar(
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  margin: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height -
                                                              120,
                                                      right: 20,
                                                      left: 20),
                                                  duration:
                                                      Duration(seconds: 10),
                                                  backgroundColor: Colors.red,
                                                  content: const Text(
                                                    'Please check the form again!!',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.done_all_outlined,
                                              size: 53,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: size.width / 30,
                                            top: size.width / 30,
                                            bottom: 150.0),
                                        child: Text(
                                          'CONFIRM',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Extra.accentColor),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
