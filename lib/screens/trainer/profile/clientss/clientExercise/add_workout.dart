import 'dart:async';
import 'package:fitness_app/extra/color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddWorkout extends StatefulWidget {
  String cKey;
  AddWorkout({Key? key, required this.cKey}) : super(key: key);

  @override
  State<AddWorkout> createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {
  final TextEditingController workoutNameController = TextEditingController();
  final TextEditingController setController = TextEditingController();
  final TextEditingController repController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _database = FirebaseDatabase.instance.ref();
  // late StreamSubscription _workoutInfoStream;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            height: size.height / 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width / 2,
                child: TextFormField(
                  style: const TextStyle(color: Colors.black),
                  controller: workoutNameController,
                  validator: (value) {
                    if (value == '') {
                      return 'Exercise can\'t be empty';
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromRGBO(255, 255, 255, 0.5),
                    labelText: 'Exercise',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Extra.accentColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.height / 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width / 4.3,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.black),
                  controller: setController,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Set can\'t be empty';
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromRGBO(255, 255, 255, 0.5),
                    labelText: 'Sets',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(10),
                        ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
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
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.black),
                  controller: repController,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Reps can\'t be empty';
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromRGBO(255, 255, 255, 0.5),
                    labelText: 'Reps',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(10),
                        ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Extra.accentColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                color: Extra.accentColor,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newWorkout = <String, dynamic>{
                      'name': workoutNameController.text.toString(),
                      'reps': int.parse(repController.text),
                      'sets': int.parse(setController.text),
                    };
                    _database
                        .child('workouts')
                        .child(widget.cKey.toString())
                        .push()
                        .set(newWorkout)
                        .then((value) {
                      Fluttertoast.showToast(
                          msg: "Workout Added!", // message
                          toastLength: Toast.LENGTH_SHORT, // length
                          gravity: ToastGravity.CENTER, // location
                          timeInSecForIosWeb: 1,
                          backgroundColor: Extra.accentColor,
                          textColor: Colors.white,
                          fontSize: 16.0 // duration
                          );
                      print('New workout has been added');
                    }).catchError(
                      (error) => print(
                          '!!!!!!! Error while adding new workout: $error !!!!!!!'),
                    );
                    // _workoutInfoStream.cancel();
                  } else {
                    final snackBar = SnackBar(
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height - 120,
                          right: 20,
                          left: 20),
                      duration: Duration(seconds: 10),
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
                icon: Icon(
                  Icons.done_all_outlined,
                  size: size.width / 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
