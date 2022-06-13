import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget MyCard({
  Color colorBg = Colors.red,
  int date = 1,
  required Color colorFg,
  required Size size,
}) {
  String _dayName = DateOperartions().getDateNAme(index: date);
  return Card(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(70)),
    color: colorBg,
    child: Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 0),
      child: Column(
        children: [
          Text(
            DateOperartions().getMonthdaysDaysName(),
            style: TextStyle(fontSize: size.width / 30, color: colorFg),
          ),
          Text(
            date.toString(),
            style: TextStyle(
                fontSize: size.width / 16.5,
                color: colorFg,
                fontWeight: FontWeight.bold),
          ),
          Text(
            _dayName.substring(0, 3),
            style: TextStyle(fontSize: size.width / 30, color: colorFg),
          ),
        ],
      ),
    ),
  );
}

Widget DisplayCard({
  Color colorBg = Colors.cyanAccent,
  int date = 0,
  Color colorFg = Colors.white,
  Size size = const Size(100.0, 100.0),
}) {
  return Container(
      width: 100,
      child:
          MyCard(colorBg: colorBg, colorFg: colorFg, date: date, size: size));
}

class DateOperartions {
  int _month = DateTime.now().month;
  int _year = DateTime.now().year;

  String getDateNAme({int index = 1}) {
    var _daynameWeek = DateFormat.EEEE().format(DateTime(_year, _month, index));
    return _daynameWeek;
  }

  int getMonthdays() {
    if (_month == 1) {
      return 31;
    } else if (_month == 2) {
      return 28;
    }
    if (_month == 3) {
      return 31;
    } else if (_month == 4) {
      return 30;
    }
    if (_month == 5) {
      return 31;
    } else if (_month == 6) {
      return 30;
    }
    if (_month == 7) {
      return 31;
    } else if (_month == 8) {
      return 31;
    }
    if (_month == 9) {
      return 30;
    } else if (_month == 10) {
      return 31;
    }
    if (_month == 11) {
      return 30;
    } else if (_month == 12) {
      return 31;
    }
    return 0;
  }

  String getMonthdaysDaysName() {
    if (_month == 1) {
      return "Jan";
    } else if (_month == 2) {
      return "Feb";
    }
    if (_month == 3) {
      return "Mar";
    } else if (_month == 4) {
      return "Apr";
    }
    if (_month == 5) {
      return "May";
    } else if (_month == 6) {
      return "Jun";
    }
    if (_month == 7) {
      return "Jul";
    } else if (_month == 8) {
      return "Aug";
    }
    if (_month == 9) {
      return "Sep";
    } else if (_month == 10) {
      return "Oct";
    }
    if (_month == 11) {
      return "Nov";
    } else if (_month == 12) {
      return "Dec";
    }

    return "Milena";
  }

  int getCurrentDate() {
    return DateTime.now().day;
  }
}
