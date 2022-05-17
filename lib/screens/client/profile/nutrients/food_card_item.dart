import 'package:fitness_app/extra/color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recase/recase.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FoodCardItem extends StatefulWidget {
  String food;
  String servingSize;
  String protein;
  String carb;
  String calories;
  FoodCardItem(
      {Key? key,
      required this.food,
      required this.servingSize,
      required this.protein,
      required this.carb,
      required this.calories})
      : super(key: key);

  @override
  State<FoodCardItem> createState() => _FoodCardItemState();
}

class _FoodCardItemState extends State<FoodCardItem> {
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
                fontSize: size.width / 31,
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
                fontSize: size.width / 31,
              ),
            ),
            SizedBox(
              width: size.width / 50,
            ),
            Flexible(
              child: Text(
                'Calories - ' + widget.calories,
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: size.width / 31,
                ),
              ),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            final newFoodItem = <String, dynamic>{
              'food': widget.food.toString(),
              'servingSize': widget.servingSize.toString(),
              'protein': widget.protein.toString(),
              'carb': widget.carb.toString(),
              'calories': widget.calories.toString(),
            };
            _database
                .child('dietInfo')
                .child(FirebaseAuth.instance.currentUser!.uid)
                .child(todayDate)
                .push()
                .set(newFoodItem)
                .then((value) {
              print('Meal has been added');
              Fluttertoast.showToast(
                  msg: "Food item added!", // message
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
          icon: Icon(Icons.add),
          color: Extra.accentColor,
        ),
      ),
    );
  }

  getValueFromtxt(String nuType, String nuValue, Size size, Color color) {
    return Text(
      nuType + ' - ' + nuValue + '    ',
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: size.width / 31,
      ),
    ).data;
  }
}
