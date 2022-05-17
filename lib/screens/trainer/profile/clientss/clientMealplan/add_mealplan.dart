import 'package:fitness_app/extra/color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddMealplan extends StatefulWidget {
  String cKey;
  AddMealplan({Key? key, required this.cKey}) : super(key: key);

  @override
  State<AddMealplan> createState() => _AddMealplanState();
}

class _AddMealplanState extends State<AddMealplan> {
  final TextEditingController mealNameController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
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
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width / 1.2,
                child: TextFormField(
                  style: const TextStyle(color: Colors.black),
                  controller: mealNameController,
                  validator: (value) {
                    if (value == '') {
                      return 'Meal name can\'t be empty\nExample: Breakfast';
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromRGBO(255, 255, 255, 0.5),
                    labelText: 'Meal',
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
            height: size.height / 35,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width / 1.2,
                child: TextFormField(
                  style: const TextStyle(color: Colors.black),
                  controller: contentController,
                  validator: (value) {
                    if (value == '') {
                      return 'Meal content can\'t be empty\nExample: eggs, chick peas';
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromRGBO(255, 255, 255, 0.5),
                    labelText: 'Meal Contents',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                color: Extra.accentColor,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newMealplan = <String, dynamic>{
                      'name': mealNameController.text.toString(),
                      'content': contentController.text.toString(),
                    };
                    _database
                        .child('mealplans')
                        .child(widget.cKey.toString())
                        .push()
                        .set(newMealplan)
                        .then((value) {
                      Fluttertoast.showToast(
                          msg: "Mealplan Added!", // message
                          toastLength: Toast.LENGTH_SHORT, // length
                          gravity: ToastGravity.CENTER, // location
                          timeInSecForIosWeb: 1,
                          backgroundColor: Extra.accentColor,
                          textColor: Colors.white,
                          fontSize: 16.0 // duration
                          );
                      print('New mealplam has been added');
                    }).catchError(
                      (error) => print(
                          '!!!!!!! Error while adding new mealplam: $error !!!!!!!'),
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
                icon: const Icon(
                  Icons.done_all_outlined,
                  size: 53,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
