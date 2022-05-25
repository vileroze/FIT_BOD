import 'dart:async';
import 'package:fitness_app/screens/client/explore/explore.dart';
import 'package:fitness_app/screens/client/client_first_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:recase/recase.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NHome extends StatefulWidget {
  @override
  State<NHome> createState() => _NHome();
}

class _NHome extends State<NHome> {
  final _firebaseStorage = FirebaseStorage.instance;
  final _database = FirebaseDatabase.instance.ref();
  int _selectedIndex = 0;
  String _userName = '';
  String _userInfoPath = '';
  late StreamSubscription _userInfoStream;
  String category = '';
  String currImg = '';

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
            'Good ' + greeting() + ', ' + _userName + '!',
            style: GoogleFonts.poppins(
                fontSize: size.width / 20, fontWeight: FontWeight.w500),
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
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: SingleChildScrollView(
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
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://firebasestorage.googleapis.com/v0/b/fitnessapp-292ab.appspot.com/o/backgroundImages%2Fpilates.jpg?alt=media&token=8ad28f01-ace7-40e2-aaf4-c2aeca89ca72'),
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
                              padding:
                                  EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
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
                margin: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                height: 160.0,
                child: ListView(
                  // This next line does the trick.
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    displayCategories(
                        'Strength',
                        "https://firebasestorage.googleapis.com/v0/b/fitnessapp-292ab.appspot.com/o/backgroundImages%2Fstrength.jpg?alt=media&token=7baa66d0-2c11-4267-876f-236d49940baa",
                        size),
                    displayCategories(
                        'Yoga',
                        "https://firebasestorage.googleapis.com/v0/b/fitnessapp-292ab.appspot.com/o/backgroundImages%2Fyoga.jpg?alt=media&token=c05936ba-badb-475d-97e6-b8db68bb65e3",
                        size),
                    displayCategories(
                        'Meditation',
                        "https://firebasestorage.googleapis.com/v0/b/fitnessapp-292ab.appspot.com/o/backgroundImages%2Fmeditation.png?alt=media&token=2d071866-85c4-4190-b987-a55f4b5ec4dc",
                        size),
                    displayCategories(
                        'Pilates',
                        "https://firebasestorage.googleapis.com/v0/b/fitnessapp-292ab.appspot.com/o/backgroundImages%2Fpilates.jpg?alt=media&token=8ad28f01-ace7-40e2-aaf4-c2aeca89ca72",
                        size),
                    displayCategories(
                        'Barre',
                        "https://firebasestorage.googleapis.com/v0/b/fitnessapp-292ab.appspot.com/o/backgroundImages%2Fbarre.jpg?alt=media&token=9a70ea96-928f-478d-ba64-0c75cdbe02b1",
                        size),
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
                      image: NetworkImage(
                          'https://firebasestorage.googleapis.com/v0/b/fitnessapp-292ab.appspot.com/o/backgroundImages%2Fbarre.jpg?alt=media&token=9a70ea96-928f-478d-ba64-0c75cdbe02b1'),
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
                              padding:
                                  EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
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
              image: NetworkImage(imagePath),
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

  // void getImgUrl(String imageName) async {
  //   String downloadUrl = await FirebaseStorage.instance
  //       .ref('backgroundImages/$imageName')
  //       .getDownloadURL();
  //   print('OOOOOOOOOOOOOOOOOOO    ' + downloadUrl);
  //   setState(() {
  //     currImg = downloadUrl;
  //   });
  // }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'morning';
    }
    if (hour < 17) {
      return 'afternoon';
    }
    return 'evening';
  }
}
