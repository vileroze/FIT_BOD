import 'package:fitness_app/screens/client/explore/explore.dart';
import 'package:fitness_app/screens/client/home/client_home.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/screens/client/profile/profile.dart';

class ClientFirstPage extends StatefulWidget {
  int currentIndx;
  // var screens = [];
  ClientFirstPage({Key? key, required this.currentIndx}) : super(key: key);

  @override
  State<ClientFirstPage> createState() => _ClientFirstPageState();
}

class _ClientFirstPageState extends State<ClientFirstPage> {
  PageController _pageController = PageController();
  var screens = [NHome(), Explore(categoryFilter: ''), Profile()];

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
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => widget.currentIndx = index);
        },
        children: <Widget>[
          screens[widget.currentIndx],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color.fromRGBO(231, 88, 20, 1),
        selectedFontSize: size.width / 40,
        unselectedFontSize: size.width / 40,
        // backgroundColor: Colors.deepOrange[50],
        backgroundColor: Colors.white,
        elevation: 20.0,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        currentIndex: widget.currentIndx,
        showUnselectedLabels: false,
        //onTap: (value) => setState(() => currentIndx = value),
        onTap: _onItemTapped,

        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: btmNavIconSize,
            ),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search_outlined,
              size: btmNavIconSize,
            ),
            label: 'EXPLORE',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle_outlined,
              size: btmNavIconSize,
            ),
            label: 'PROFILE',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      widget.currentIndx = index;
      //using this page controller you can make beautiful animation effects
      // _pageController.animateToPage(index,
      //     duration: Duration(milliseconds: 1000), curve: Curves.easeInSine);
    });
  }
}
