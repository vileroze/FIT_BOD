import 'package:fitness_app/extra/color.dart';
import 'package:fitness_app/screens/client/explore/available_class.dart';
import 'package:fitness_app/screens/client/explore/model_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Explore extends StatefulWidget {
  String categoryFilter;
  Explore({Key? key, required this.categoryFilter}) : super(key: key);

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  late DateTime _plusDay;
  late DateTime _hourOnly;
  // var _lowerValue;
  // var _upperValue;
  int _tabCheck = 0;
  RangeValues values = RangeValues(0, 1048);
  final double min = 0;
  final double max = 1048;
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(now);
  static String dateFilter = '';

  final Color _accentColor = Color.fromRGBO(231, 88, 20, 1);

  @override
  void initState() {
    var _time = DateTime.now();
    _hourOnly = DateTime(_time.year, _time.month, _time.day, _time.hour);
    _plusDay = _hourOnly.add(Duration(days: 1));
    // _lowerValue = _hourOnly.millisecondsSinceEpoch.toDouble();
    // _upperValue = _plusDay.millisecondsSinceEpoch.toDouble();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final DateTime currentDate = DateTime.now();
    // final TextTheme textTheme = Theme.of(context).textTheme;
    Size size = MediaQuery.of(context).size;
    DateTime now = DateTime.now();
    // DateTime nowRounded = DateTime(now.year, now.month, now.day, now.hour);
    // DateTime tomorrowRounded =
    //     DateTime(now.year, now.month, now.day + 1, now.hour);

    // DateFormat usHour = DateFormat.jm();
    // final tilesList = <ListTile>[];
    //---------------------------------------
    // dateFilter = '2022-05-19';
    return Scaffold(
      appBar: AppBar(
        title: Container(
          margin: EdgeInsets.only(top: size.height / 10),
          // color: Colors.amber,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'EXPLORE',
                style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.7),
                    fontSize: size.width / 10,
                    letterSpacing: 5,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        toolbarHeight: size.height / 3.5,
        elevation: 5,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  'https://firebasestorage.googleapis.com/v0/b/fitnessapp-292ab.appspot.com/o/backgroundImages%2Fexplore.png?alt=media&token=22b409b2-d6c4-413a-bf0b-39bbf12cc70b'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.transparent.withOpacity(0.7), BlendMode.dstATop),
            ),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(208, 65, 70, 1), //#D03E49
                Color.fromRGBO(244, 122, 13, 1),
              ],
            ),
            boxShadow: [
              BoxShadow(
                  color: _accentColor,
                  spreadRadius: 5,
                  blurRadius: size.width / 10),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                // borderRadius: BorderRadius.circular(10),
                border:
                    Border(bottom: BorderSide(color: Colors.grey, width: 1.0)),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 25),
                child: SliderTheme(
                  data: SliderThemeData(
                    thumbColor: Colors.white,
                    activeTrackColor: Extra.accentColor,
                    inactiveTrackColor: Color.fromRGBO(228, 228, 230, 1),
                    rangeThumbShape: RoundRangeSliderThumbShape(
                        enabledThumbRadius: 13, elevation: 5),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10.0),
                        height: size.height / 7,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _getRemaningDays(),
                          itemBuilder: (BuildContext context, int index) {
                            int _currentDate =
                                DateOperartions().getCurrentDate();
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _tabCheck = index;
                                  String _fdayNum = '';
                                  int _dayNum = _getList()[_tabCheck];
                                  if (_dayNum < 10) {
                                    _fdayNum = '0' + _dayNum.toString();
                                  } else {
                                    _fdayNum = _dayNum.toString();
                                  }
                                  String _year = DateFormat.y().format(now);
                                  String _month = DateFormat('MM').format(now);
                                  dateFilter =
                                      _year + '-' + _month + '-' + _fdayNum;

                                  // AvailableClassList(
                                  //     categoryFilter: widget.categoryFilter,
                                  //     dateFilter: dateFilter);
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: size.width / 45),
                                child: MyCard(
                                    size: size,
                                    date: _getList()[index],
                                    colorFg: _tabCheck == index
                                        ? Colors.white
                                        : Extra.accentColor,
                                    colorBg: _tabCheck == index
                                        ? Extra.accentColor
                                        : Colors.transparent),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: size.height / 2,
              child: AvailableClassList(
                categoryFilter: widget.categoryFilter,
                dateFilter: dateFilter,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<int> _getList() {
  List<int> _datesList = <int>[];
  int _currentDate = DateOperartions().getCurrentDate();
  int _totalDays = DateOperartions().getMonthdays();
  for (int j = _currentDate; j <= _totalDays; j++) {
    _datesList.add(j);
  }
  return _datesList;
}

int _getRemaningDays() {
  int _currentDate = DateOperartions().getCurrentDate();
  int _totalDays = DateOperartions().getMonthdays();
  int _coutner = 0;
  for (int j = _currentDate; j <= _totalDays; j++) {
    _coutner++;
  }
  return _coutner;
}
