import 'package:fitness_app/extra/color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recase/recase.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ViewCalorieHelper extends StatefulWidget {
  String food;
  String servingSize;
  String protein;
  String carb;
  String calories;
  String foodKey;
  ViewCalorieHelper({
    Key? key,
    required this.food,
    required this.servingSize,
    required this.protein,
    required this.carb,
    required this.calories,
    required this.foodKey,
  }) : super(key: key);

  @override
  State<ViewCalorieHelper> createState() => _ViewCalorieHelperState();
}

class _ViewCalorieHelperState extends State<ViewCalorieHelper> {
  final _database = FirebaseDatabase.instance.ref();
  final String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      child: ListTile(
        title: Row(
          children: [
            Text(
              widget.food.toString().titleCase + ' (',
              style: TextStyle(
                fontSize: size.width / 23,
              ),
            ),
            Text(
              widget.servingSize + ' gm)',
              style: TextStyle(
                fontSize: size.width / 27,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        subtitle: Row(
          children: [
            Text(
              'Protein - ' + widget.protein,
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: size.width / 33,
              ),
            ),
            SizedBox(
              width: size.width / 50,
            ),
            Text(
              'Carbs - ' + widget.carb,
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: size.width / 33,
              ),
            ),
            SizedBox(
              width: size.width / 50,
            ),
            Text(
              'Calories - ' + widget.calories,
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
                fontSize: size.width / 33,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            _database
                .child('dietInfo')
                .child(FirebaseAuth.instance.currentUser!.uid)
                .child(todayDate)
                .child(widget.foodKey)
                .remove()
                .then((value) {
              Fluttertoast.showToast(
                  msg: "Food item removed!", // message
                  toastLength: Toast.LENGTH_SHORT, // length
                  gravity: ToastGravity.CENTER, // location
                  timeInSecForIosWeb: 1,
                  backgroundColor: Extra.accentColor,
                  textColor: Colors.white,
                  fontSize: 16.0 // duration
                  );
            }).catchError(
              (error) => print(
                  '!!!!!!! Error while adding new food entry: $error !!!!!!!'),
            );
          },
          icon: Icon(Icons.remove_circle_rounded),
          color: Extra.accentColor,
        ),
      ),
    );
  }
}
