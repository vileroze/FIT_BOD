import 'package:fitness_app/screens/trainer/profile/profile.dart';
import 'package:flutter/material.dart';

class TrainerFirstPage extends StatefulWidget {
  static int currentIndx = 0;
  TrainerFirstPage({Key? key}) : super(key: key);

  @override
  State<TrainerFirstPage> createState() => _TrainerFirstPageState();
}

class _TrainerFirstPageState extends State<TrainerFirstPage> {
  PageController _pageController = PageController();

  var screens = [
    ProfileTrainer(),
    Container(
      child: Text('Coming soon'),
    ),
  ];

  @override
  void initState() {
    super.initState();
    //_pageController = PageController();
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
          setState(() => TrainerFirstPage.currentIndx = index);
        },
        children: <Widget>[
          screens[TrainerFirstPage.currentIndx],
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
        currentIndex: TrainerFirstPage.currentIndx,
        showUnselectedLabels: false,
        //onTap: (value) => setState(() => currentIndx = value),
        onTap: _onItemTapped,

        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle_outlined,
              size: btmNavIconSize,
            ),
            label: 'PROFILE',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_sharp,
              size: btmNavIconSize,
            ),
            label: 'CHATS',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      TrainerFirstPage.currentIndx = index;
      //using this page controller you can make beautiful animation effects
      // _pageController.animateToPage(index,
      //     duration: Duration(milliseconds: 1000), curve: Curves.easeInSine);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
