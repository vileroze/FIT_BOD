import 'dart:async';

import 'package:fitness_app/extra/color.dart';
import 'package:fitness_app/screens/admin/admin_first_page.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/screens/client/client_first_page.dart';
import 'package:fitness_app/screens/trainer/trainer_first_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final spinkit = SpinKitSpinningLines(
  color: Extra.accentColor,
  size: 180.0,
);

class PageRedirect extends StatefulWidget {
  const PageRedirect({Key? key}) : super(key: key);

  @override
  State<PageRedirect> createState() => _PageRedirectState();
}

class _PageRedirectState extends State<PageRedirect> {
  late StreamSubscription _userTypeStream;
  final _database = FirebaseDatabase.instance.ref();
  String ff = 'asdfasdf';
  int flag = 0;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // checkInternet();
    _selectUsetType();
  }

  _selectUsetType() {
    _userTypeStream = _database
        .child(
            'userDetails/' + FirebaseAuth.instance.currentUser!.uid.toString())
        .child('userType')
        .onValue
        .listen((event) {
      String uType = event.snapshot.value.toString();
      if (uType == 'Client') {
        setState(() {
          flag = 11;
        });
      } else if (uType == 'Trainer') {
        setState(() {
          flag = 22;
        });
      } else if (uType == 'Admin') {
        setState(() {
          flag = 33;
        });
      }

      _userTypeStream.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (flag == 11) {
      return ClientFirstPage(
        currentIndx: 0,
      );
    }
    if (flag == 22) {
      return TrainerFirstPage();
    }

    if (flag == 33) {
      return AdminFirstPage();
    }

    return Container(
      color: Colors.red[50],
      child: Center(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            spinkit,
            SizedBox(
              height: 30,
            ),
            Material(
              color: Colors.red[50],
              child: Text(
                'Waiting for connection....',
                style: TextStyle(
                  fontSize: 13,
                  decoration: null,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}




// import 'dart:async';

// import 'package:fitness_app/extra/color.dart';
// import 'package:fitness_app/screens/admin/admin_first_page.dart';
// import 'package:flutter/material.dart';
// import 'package:fitness_app/screens/client/client_first_page.dart';
// import 'package:fitness_app/screens/trainer/trainer_first_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

// final spinkit = SpinKitSpinningLines(
//   color: Extra.accentColor,
//   size: 200.0,
// );

// class PageRedirect extends StatefulWidget {
//   const PageRedirect({Key? key}) : super(key: key);

//   @override
//   State<PageRedirect> createState() => _PageRedirectState();
// }

// class _PageRedirectState extends State<PageRedirect> {
//   late StreamSubscription _userTypeStream;
//   final _database = FirebaseDatabase.instance.ref();
//   String ff = 'asdfasdf';
//   int flag = 0;
//   @override
//   void initState() {
//     // TODO: implement initState

//     super.initState();
//     _selectUsetType();
//   }

//   _selectUsetType() {
//     _userTypeStream = _database
//         .child(
//             'userDetails/' + FirebaseAuth.instance.currentUser!.uid.toString())
//         .child('userType')
//         .onValue
//         .listen((event) {
//       String uType = event.snapshot.value.toString();
//       if (uType == 'Client') {
//         setState(() {
//           flag = 11;
//         });
//       } else if (uType == 'Trainer') {
//         setState(() {
//           flag = 22;
//         });
//       } else if (uType == 'Admin') {
//         setState(() {
//           print("LLLLLLLLLLLLLLLLLLLLLLLLLLLLLL");
//           flag = 33;
//         });
//       }

//       _userTypeStream.cancel();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (flag == 11) {
//       return ClientFirstPage(
//         currentIndx: 0,
//       );
//     }
//     if (flag == 22) {
//       return TrainerFirstPage();
//     }

//     if (flag == 33) {
//       return AdminFirstPage();
//     }

//     return Container(
//       color: Colors.red[50],
//       child: Center(
//         child: Column(
//           // crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             spinkit,
//             SizedBox(
//               height: 30,
//             ),
//             Material(
//               color: Colors.red[50],
//               child: Text(
//                 'No internet connection!',
//                 style: TextStyle(
//                   fontSize: 13,
//                   decoration: null,
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
