// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:intl/intl.dart';

// class AllChatsss extends StatefulWidget {
//   const AllChatsss({Key? key}) : super(key: key);

//   @override
//   State<AllChatsss> createState() => _AllChatsssState();
// }

// class _AllChatsssState extends State<AllChatsss> {
//   final _database = FirebaseDatabase.instance.ref();
//   DateFormat dateFormat = DateFormat();
//   int timeStamp = int.parse(DateTime.now().millisecondsSinceEpoch.toString());

//   String userId = 'AA';
//   static List<int> allTimeStamps = [];

//   // static var chatCards = <AllChatItem>[];

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // _getSortedTimeStamps();
//   }

//   // void _getSortedTimeStamps() {
//   //   _database.child('chats').child('aabb').onValue.listen((event) {
//   //     final allMessages = Map<dynamic, dynamic>.from(
//   //         (event.snapshot.value ?? {}) as Map<dynamic, dynamic>);

//   //     // print(allMessages);
//   //     allMessages.forEach((key, value) {
//   //       final individualDetail = Map<String, dynamic>.from(value);
//   //       String clientID = key.toString();

//   //       setState(() {
//   //         print(individualDetail['timeStamp']);
//   //         allTimeStamps.add(individualDetail['timeStamp']);
//   //       });

//   //       // final chItem = AllChatItem(allTimeStamps: allTimeStamps);
//   //       // chatCards.add(chItem);
//   //     });
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     // print(allTimeStamps);

//     // Query chatQuery = _database.child('chats').child('aabb').startAt().limitToLast(20);

//     // chatQuery.onValue.listen((event) {
//     //   print(event.snapshot.value.toString());
//     // });

//     return StreamBuilder(
//         stream: _database
//             .child('chats')
//             .child('aabb')
//             .orderByChild("timeStamp")
//             .onValue,
//         builder: (context, snapshot) {
//           List<int> allTimeStamps = [];
//           // final chatCards = <AllChatItem>[];

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.connectionState == ConnectionState.active) {
//             if (snapshot.hasData) {
//               final allMessages = Map<dynamic, dynamic>.from(
//                   ((snapshot.data! as DatabaseEvent).snapshot.value ?? {})
//                       as Map<dynamic, dynamic>);

//               allMessages.forEach((key, value) {
//                 final individualDetail = Map<String, dynamic>.from(value);
//                 String clientID = key.toString();
//                 // print(individualDetail);

//                 allTimeStamps.add(int.parse(key.toString()));
//                 allTimeStamps.sort((a, b) => a.compareTo(b));

//                 // print(allTimeStamps);

//                 // final chItem = AllChatItem(allTimeStamps: allTimeStamps);
//                 // chatCards.add(chItem);
//               });
//             }
//           }

//           // print(allTimeStamps);

//           allTimeStamps.forEach(
//             (element) {
//               // print(_database
//               //     .child('chats')
//               //     .child('aabb')
//               //     .child(element.toString())
//               //     .path);

//               _database
//                   .child('chats')
//                   .child('aabb')
//                   .child(element.toString())
//                   .once()
//                   .then((event) {
//                 print(event.snapshot.value);

//                 final individualDetail =
//                     List<dynamic>.from(event.snapshot.value as List<dynamic>);
//               });
//             },
//           );

//           // aa.sort((a, b) => a.compareTo(b));
//           // print(aa);

//           // aa.forEach((element) {
//           //   _database
//           //       .child('chats')
//           //       .child('aabb')
//           //       .orderByChild('timeStamp')
//           //       .onValue
//           //       .listen((event) {
//           //     final ll = Map<dynamic, dynamic>.from(
//           //         event.snapshot.value as Map<dynamic, dynamic>);

//           //     ll.forEach((key, value) {
//           //       final gg = Map<dynamic, dynamic>.from(value);
//           //       // print(gg);
//           //       if (gg['timeStamp'].toString() == element.toString()) {
//           //         MainAxisAlignment alignment = MainAxisAlignment.start;

//           //         Color msgColor = Color.fromHex(code: '#ffffff');

//           //         if (gg['sentBy'] == userId) {
//           //           alignment = MainAxisAlignment.end;
//           //           msgColor = Color.fromHex(code: '#66ff66');
//           //         }

//           //         final chatItem = AllChatItem(
//           //           userName: gg['sentBy'],
//           //           message: gg['message'],
//           //           sender: gg['sentBy'],
//           //           timeStamp: gg['timeStamp'],
//           //           alignment: alignment,
//           //           // msgColor: msgColor,
//           //         );

//           //         chatCards.add(chatItem);
//           //       }
//           //     });
//           //   });
//           //   print(chatCards);
//           // });
//           return Container();

//           // return Container(
//           //   padding: EdgeInsets.all(10),
//           //   color: Colors.amber,
//           //   height: size.height / 1.6,
//           //   child: ListView(
//           //     shrinkWrap: true,
//           //     children: chatCards,
//           //   ),
//           // );
//         });
//   }
// }
