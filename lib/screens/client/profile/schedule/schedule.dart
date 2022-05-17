import 'package:fitness_app/screens/client/profile/schedule/schedule_builder.dart';
import 'package:flutter/material.dart';

class Schedule extends StatefulWidget {
  const Schedule({
    Key? key,
  }) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size.width / 20),
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
          child: BookedCourses(),
        ),
      ),
    );
  }
}
