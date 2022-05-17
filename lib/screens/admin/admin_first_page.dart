import 'package:fitness_app/screens/admin/allClients/all_clients.dart';
import 'package:fitness_app/screens/admin/allTrainers/all_trainers.dart';
import 'package:flutter/material.dart';

class AdminFirstPage extends StatefulWidget {
  static int currentIndx = 0;
  AdminFirstPage({Key? key}) : super(key: key);

  @override
  State<AdminFirstPage> createState() => _AdminFirstPageState();
}

class _AdminFirstPageState extends State<AdminFirstPage> {
  PageController _pageController = PageController();
  var screens = [
    AllClients(),
    AllTrainers(),
  ];

  @override
  void initState() {
    super.initState();
    //_pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double btmNavIconSize = size.height / 25;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => AdminFirstPage.currentIndx = index);
        },
        children: <Widget>[
          screens[AdminFirstPage.currentIndx],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color.fromRGBO(231, 88, 20, 1),
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        // backgroundColor: Colors.deepOrange[50],
        backgroundColor: Colors.white,
        elevation: 20.0,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        currentIndex: AdminFirstPage.currentIndx,
        showUnselectedLabels: false,
        //onTap: (value) => setState(() => currentIndx = value),
        onTap: _onItemTapped,

        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle_outlined,
              size: btmNavIconSize,
            ),
            label: 'CLIETNS',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.sports_gymnastics,
              size: btmNavIconSize,
            ),
            label: 'TRAINERS',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      AdminFirstPage.currentIndx = index;
      //using this page controller you can make beautiful animation effects
      // _pageController.animateToPage(index,
      //     duration: Duration(milliseconds: 1000), curve: Curves.easeInSine);
    });
  }
}
