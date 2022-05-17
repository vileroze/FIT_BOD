// import 'dart:async';

// import 'package:fitness_app/extra/color.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';

// class AllChatItem extends StatefulWidget {
//   // String userName;
//   // String message;
//   // String sender;
//   // int timeStamp;
//   // Color msgColor;
//   // MainAxisAlignment alignment;
//   List<int> allTimeStamps;

//   AllChatItem({
//     Key? key,
//     required this.allTimeStamps,
//     // required this.userName,
//     // required this.message,
//     // required this.sender,
//     // required this.timeStamp,
//     // required this.alignment,
//     // required this.msgColor,
//   }) : super(key: key);

//   @override
//   State<AllChatItem> createState() => _AllChatCardItemState();
// }

// class _AllChatCardItemState extends State<AllChatItem> {
//   final _database = FirebaseDatabase.instance.ref();
//   late StreamSubscription _userVerifyStream;

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     final detailFontSize = size.width / 25;

//     return StreamBuilder(
//         stream: _database
//             .child('chats')
//             .child('aabb')
//             .orderByChild('timeStamp')
//             .onValue,
//         builder: (context, snapshot) {
//           final allMessages = Map<dynamic, dynamic>.from(
//               ((snapshot.data! as DatabaseEvent).snapshot.value ?? {})
//                   as Map<dynamic, dynamic>);

//                   widget.allTimeStamps.forEach((element) {
//                     // print(gg);
//                     if (gg['timeStamp'].toString() == element.toString()) {
//                       MainAxisAlignment alignment = MainAxisAlignment.start;

//                       Color msgColor = Color.fromHex(code: '#ffffff');

//                       if (gg['sentBy'] == userId) {
//                         alignment = MainAxisAlignment.end;
//                         msgColor = Color.fromHex(code: '#66ff66');
//                       }

//                       final chatItem = AllChatItem(
//                         userName: gg['sentBy'],
//                         message: gg['message'],
//                         sender: gg['sentBy'],
//                         timeStamp: gg['timeStamp'],
//                         alignment: alignment,
//                         // msgColor: msgColor,
//                       );

//                       chatCards.add(chatItem);
//                     }
//                 print(chatCards);
//               });
//         });
//   }
// }





// return Column(
//       children: [
//         Row(
//           mainAxisAlignment: widget.alignment,
//           children: [
//             Container(
//               color: (Colors.white),
//               child: Text(
//                 widget.message,
//                 style: TextStyle(fontSize: 20),
//               ),
//             ),
//           ],
//         ),
//         Row(
//           mainAxisAlignment: widget.alignment,
//           children: [
//             Container(
//               child: Text(
//                 widget.timeStamp.toString(),
//                 style: TextStyle(fontSize: 10),
//               ),
//             ),
//           ],
//         )
//       ],
//     );