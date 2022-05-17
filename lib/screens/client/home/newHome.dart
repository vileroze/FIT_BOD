import 'dart:async';
import 'package:fitness_app/screens/client/explore/explore.dart';
import 'package:fitness_app/screens/client/client_first_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:recase/recase.dart';
import 'package:google_fonts/google_fonts.dart';

class NHome extends StatefulWidget {
  @override
  State<NHome> createState() => _NHome();
}

class _NHome extends State<NHome> {
  final _database = FirebaseDatabase.instance.ref();
  int _selectedIndex = 0;
  String _userName = '';
  String _userInfoPath = '';
  late StreamSubscription _userInfoStream;
  String category = '';

  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

  void _activateListeners() {
    _userInfoPath = '/userDetails/' + FirebaseAuth.instance.currentUser!.uid;

    _userInfoStream =
        _database.child(_userInfoPath.trim()).onValue.listen((event) {
      final data = Map<String, dynamic>.from(
          event.snapshot.value as Map<dynamic, dynamic>);

      final uName = data['userName'] as String;

      setState(() {
        _userName = uName;
        _userName = _userName.split(' ').first.sentenceCase;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double titleFontSize = size.width / 17;
    double subtitleFont = size.width / 30;
    double imageCaptionSize = size.width / 25;

    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 243, 245, 1),
      appBar: AppBar(
        toolbarHeight: size.height / 10,
        elevation: 0,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        title: Padding(
          padding: EdgeInsets.only(top: 40.0, bottom: 15.0),
          child: Text(
            'Good morning, ' + _userName + '!',
            style: GoogleFonts.poppins(
                fontSize: size.width / 20, fontWeight: FontWeight.w400),
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(208, 65, 70, 1), //#D03E49
                Color.fromRGBO(244, 122, 13, 1),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20.0, left: 15.0),
              child: Text(
                'Your workouts, your way!',
                style: GoogleFonts.robotoSlab(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text(
                'Choose from a variety of fitness classes',
                style: TextStyle(
                  fontSize: subtitleFont,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                height: 160.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/home_page/pilates.jpg"),
                    colorFilter: ColorFilter.mode(
                        Color.fromARGB(200, 0, 0, 0), BlendMode.dstATop),
                    fit: BoxFit.cover,
                  ),
                  color: Colors.black,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 47.0),
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'Virtual Classes',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                            letterSpacing: 1.0,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ClientFirstPage(currentIndx: 1),
                                ),
                                (route) => false);
                          },
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                            child: Text(
                              'EXPLORE',
                              style: TextStyle(
                                fontSize: 13.0,
                                fontFamily: 'OpenSans',
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0, left: 15.0),
              child: Text(
                'Explore Categories',
                style: GoogleFonts.robotoSlab(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              height: 160.0,
              child: ListView(
                // This next line does the trick.
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  displayCategories(
                      'Strength', "assets/home_page/strength.jpg", size),
                  displayCategories('Yoga', "assets/home_page/yoga.jpg", size),
                  displayCategories(
                      'Meditation', "assets/home_page/meditation.png", size),
                  displayCategories(
                      'Pilates', "assets/home_page/pilates.jpg", size),
                  displayCategories(
                      'Barre', "assets/home_page/barre.jpg", size),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0, left: 15.0),
              child: Text(
                'Sweat from home!',
                style: GoogleFonts.robotoSlab(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text(
                'Stay in shape and support your favourite creators.',
                style: TextStyle(
                  fontSize: subtitleFont,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                height: 160.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/home_page/barre.jpg"),
                    colorFilter: ColorFilter.mode(
                        Color.fromARGB(200, 0, 0, 0), BlendMode.dstATop),
                    fit: BoxFit.cover,
                  ),
                  color: Colors.black,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 47.0),
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'Virtual Classes',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                            letterSpacing: 1.0,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                            child: Text(
                              'EXPLORE',
                              style: TextStyle(
                                fontSize: 13.0,
                                fontFamily: 'OpenSans',
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    _userInfoStream.cancel();
    super.deactivate();
  }

  Widget displayCategories(String caption, String imagePath, Size size) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => Explore(
              categoryFilter: caption.toLowerCase(),
            ),
            maintainState: false,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 5.0),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              colorFilter: ColorFilter.mode(
                  Color.fromARGB(220, 0, 0, 0), BlendMode.dstATop),
              fit: BoxFit.cover,
            ),
            color: Colors.black,
            borderRadius: BorderRadius.all(
              Radius.circular(13),
            ),
          ),
          width: 140.0,
          child: Center(
            child: Text(
              caption.titleCase,
              style: TextStyle(
                fontSize: size.width / 25,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
                letterSpacing: 1.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
