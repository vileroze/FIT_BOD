// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
// import 'package:agora_uikit/agora_uikit.dart';

// const appId = "2e434cbf455c4d6593dcafc2c52845d7";
// const token =
//     "00062e434cbf455c4d6593dcafc2c52845d7IACn70FidL5EhAIq/rNfeBYWEl4mIXn5IRL1A3+LqSzwowrCxmsAAAAAEAD9FOMnYed7YgEAAQBa5nti";

// // Instantiate the client
// class VideoCall extends StatefulWidget {
//   const VideoCall({Key? key}) : super(key: key);

//   @override
//   State<VideoCall> createState() => _VideoCallState();
// }

// class _VideoCallState extends State<VideoCall> {
//   @override
//   void initState() {
//     super.initState();
//     initForAgora();
//   }

//   late final _remoteUid;
//   late RtcEngine _engine;

//   Future<void> initForAgora() async {
//     print(':::::::::::::::::::::::::::');
//     //get permission
//     await [Permission.microphone, Permission.camera].request();

//     //create the engine
//     _engine = await RtcEngine.create(appId);

//     await _engine.enableVideo();

//     print(':::::::::::::::::::::::::::');
//     _engine.setEventHandler(
//       RtcEngineEventHandler(
//         joinChannelSuccess: (String channel, int uid, int elapsed) {
//           print(':::::::::::::::::::::::::::');
//           print("local user $uid joined");
//         },
//         userJoined: (int uid, int elapsed) {
//           print("remote user $uid joined");
//           setState(() {
//             _remoteUid = uid;
//           });
//         },
//         userOffline: (int uid, UserOfflineReason reason) {
//           print('remote user $uid left channel');
//           setState(() {
//             _remoteUid = null;
//           });
//         },
//       ),
//     );

//     await _engine.joinChannel(token, 'trainer1', null, 0);
//   }

//   // Create UI with local view and remote view
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Agora Video Call'),
//       ), // AppBar
//       body: Stack(children: [
//         Center(
//           child: _renderRemoteVideo(),
//         ), // Center
//         Align(
//           alignment: Alignment.topLeft,
//           child: Container(
//             width: 100,
//             height: 100,
//             child: Center(
//               child: _renderLocalPreview(),
//             ),
//           ),
//         ),
//       ]),
//     );
//   }

//   // current user video
//   Widget _renderLocalPreview() {
//     return RtcLocalView.SurfaceView();
//   }

//   // remote user video
//   Widget _renderRemoteVideo() {
//     if (_remoteUid != null) {
//       return RtcRemoteView.SurfaceView(
//         uid: _remoteUid,
//       );
//     } else {
//       return Text(
//         'Please wait remote user join',
//         textAlign: TextAlign.center,
//       );
//     }
//   }
// }
