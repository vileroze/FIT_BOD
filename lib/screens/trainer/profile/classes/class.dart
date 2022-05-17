import 'package:fitness_app/screens/client/profile/schedule/schedule_builder.dart';
import 'package:fitness_app/screens/trainer/profile/classes/class_builder.dart';
import 'package:fitness_app/screens/trainer/profile/classes/class_helper.dart';
import 'package:flutter/material.dart';

class Classes extends StatefulWidget {
  const Classes({
    Key? key,
  }) : super(key: key);

  @override
  State<Classes> createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  @override
  Widget build(BuildContext context) {
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
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: AllClasses(),
        ),
      ),
    );
  }
}
