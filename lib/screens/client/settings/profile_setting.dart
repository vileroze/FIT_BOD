import 'dart:io';

import 'package:fitness_app/extra/color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:recase/recase.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({Key? key}) : super(key: key);

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final _database = FirebaseDatabase.instance.ref();
  File? file;
  final _firebaseStorage = FirebaseStorage.instance;
  String imgUrl = '';

  String userName = '';
  String uemail = '';
  String uphonenumber = '';
  String userType = '';

  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

  void _activateListeners() {
    final userUrlRef = _database
        .child('/userDetails/' + FirebaseAuth.instance.currentUser!.uid + '/')
        .onValue
        .listen((event) {
      final data = Map<String, dynamic>.from(
          event.snapshot.value as Map<dynamic, dynamic>);
      final String uUrl = data['profileImgUrl'] as String;
      final String name = data['userName'] as String;
      final String email = data['email'] as String;
      final String phonenumber = data['phoneNumber'] as String;
      final String uType = data['userType'] as String;
      setState(() {
        imgUrl = uUrl;
        userName = name;
        uemail = email;
        uphonenumber = phonenumber;
        userType = uType;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double detailFontSize = size.width / 25;
    final fileName = file != null
        ? file!.path.split('/').last.toString()
        : 'No File Selected';

    return Scaffold(
      backgroundColor: Colors.deepOrange[50],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Extra.accentColor, //change your color here
        ),
        title: Text(
          'PROFILE SETTINGS',
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
        elevation: 1.0,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: size.width / 4.5, top: size.height / 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                border: Border.all(color: Colors.white),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(2, 2),
                    spreadRadius: 2,
                    blurRadius: 1,
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundImage: (imgUrl == '')
                    ? AssetImage('assets/profile/random_profile.jpg')
                        as ImageProvider
                    : NetworkImage(imgUrl),
                radius: size.width / 5,
                backgroundColor: Colors.deepOrange[500],
              ),
            ),
            Text(
              fileName,
              style: TextStyle(
                fontSize: size.width / 30,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextButton.icon(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.white), //Background Color
                elevation: MaterialStateProperty.all(3), //Defines Elevation
                shadowColor: MaterialStateProperty.all(
                    Colors.black), //Defines shadowColor
              ),
              onPressed: () {
                uploadImage();
              },
              label: Text(
                'Upload image',
                style: TextStyle(
                  fontSize: size.width / 20,
                  color: Extra.accentColor,
                ),
              ),
              icon: Icon(
                Icons.cloud_upload_outlined,
                color: Extra.accentColor,
                size: size.width / 12,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                'Name : ' + userName.titleCase,
                style: TextStyle(
                  color: Extra.accentColor,
                  fontSize: detailFontSize,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                'Email : ' + uemail,
                style: TextStyle(
                  color: Extra.accentColor,
                  fontSize: detailFontSize,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                'Phone : ' + uphonenumber,
                style: TextStyle(
                  color: Extra.accentColor,
                  fontSize: detailFontSize,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                'Type : ' + userType,
                style: TextStyle(
                  color: Extra.accentColor,
                  fontSize: detailFontSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future uploadImage() async {
    final results = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );

    if (results == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file was selected'),
        ),
      );
      return null;
    }

    final path = results.files.single.path!;
    final fileName = results.files.single.name;

    setState(() {
      file = File(path);
    });

    try {
      await _firebaseStorage
          .ref('profileImages/$fileName')
          .putFile(file as File);

      String downloadUrl = await _firebaseStorage
          .ref('profileImages/$fileName')
          .getDownloadURL();

      final userProfileUrlRef = _database
          .child('/userDetails/' + FirebaseAuth.instance.currentUser!.uid);

      userProfileUrlRef.update({'profileImgUrl': downloadUrl});

      setState(() {
        imgUrl = downloadUrl;
      });

      Fluttertoast.showToast(
          msg: "Profile Image Updated!", // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.CENTER, // location
          timeInSecForIosWeb: 1,
          backgroundColor: Extra.accentColor,
          textColor: Colors.white,
          fontSize: 16.0 // duration
          );
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }
}
