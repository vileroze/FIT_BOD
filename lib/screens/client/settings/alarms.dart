import 'package:fitness_app/extra/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:intl/intl.dart';
import 'package:recase/recase.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Alarms extends StatefulWidget {
  const Alarms({Key? key}) : super(key: key);

  @override
  State<Alarms> createState() => _AlarmsState();
}

class _AlarmsState extends State<Alarms> {
  TextEditingController titleController = TextEditingController();

  TimeOfDay _selectedTime = TimeOfDay.now();
  String timeReturned = '';
  String h24r = '';

  final _formKey = GlobalKey<FormState>();

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
        DateTime beforeTimeFormat = DateFormat("hh:mm a").parse(timeReturned);
        h24r = DateFormat("HH:mm").format(beforeTimeFormat);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.deepOrange[50],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Extra.accentColor, //change your color here
        ),
        title: Text(
          'ALARMS',
          style: TextStyle(
            fontSize: size.width / 27,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
            letterSpacing: 2.0,
            color: Extra.accentColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrange[50],
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width / 2.5,
                child: Container(
                  height: 65,
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      validator: (value) {
                        if (value != '') {
                        } else {
                          return 'Name can\'t be empty';
                        }
                      },
                      controller: titleController,
                      style: TextStyle(color: Extra.accentColor),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Extra.accentColor),
                        ),
                        filled: false,
                        fillColor: Colors.deepOrange[50],
                        labelText: "Alarm Name",
                        labelStyle: TextStyle(color: Extra.accentColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Extra.accentColor)),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              SizedBox(
                width: size.width / 2,
                child: Container(
                  height: 65,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.watch,
                      color: Extra.accentColor,
                    ),
                    label: Text(
                      'PICK A TIME',
                      style: TextStyle(
                          fontSize: size.width / 30, color: Extra.accentColor),
                    ),
                    onPressed: _pickTimeDialog,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      side: BorderSide(color: Extra.accentColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text('Selected time: ' + timeReturned),
          Container(
            margin:
                EdgeInsets.only(left: size.width / 10, top: size.width / 20),
            child: Row(
              children: [
                SizedBox(
                  width: size.width / 3,
                  child: Container(
                    height: 65,
                    child: ElevatedButton.icon(
                      icon: Icon(
                        Icons.add_alarm_outlined,
                        color: Extra.accentColor,
                      ),
                      label: Text(
                        'CREATE ALARM',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: size.width / 30,
                            color: Extra.accentColor),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final splitTime = h24r.trim().split(':').toString();

                          int hour = int.parse(splitTime[1] + splitTime[2]);
                          int minutes = int.parse(splitTime[5] + splitTime[6]);
                          String title = 'asdfasd';

                          FlutterAlarmClock.createAlarm(hour, minutes,
                              title: titleController.text.titleCase);
                          Fluttertoast.showToast(
                              msg: "Alarm Added!", // message
                              toastLength: Toast.LENGTH_SHORT, // length
                              gravity: ToastGravity.CENTER, // location
                              timeInSecForIosWeb: 1,
                              backgroundColor: Extra.accentColor,
                              textColor: Colors.white,
                              fontSize: 16.0 // duration
                              );
                        } else {}
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        side: BorderSide(color: Extra.accentColor),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: size.width / 7),
                SizedBox(
                  width: size.width / 3,
                  child: Container(
                    height: 65,
                    child: ElevatedButton.icon(
                      icon: Icon(
                        Icons.access_alarm,
                        color: Extra.accentColor,
                      ),
                      label: Text(
                        'SHOW ALARMS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: size.width / 30,
                            color: Extra.accentColor),
                      ),
                      onPressed: () {
                        FlutterAlarmClock.showAlarms();
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          side: BorderSide(color: Extra.accentColor)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
