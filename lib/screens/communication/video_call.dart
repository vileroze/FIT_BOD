import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:http/http.dart';
import 'dart:convert';

class VideoCall extends StatefulWidget {
  String channelName = '';
  VideoCall({Key? key, required this.channelName}) : super(key: key);

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  // Initialize the Agora Engine
  late final AgoraClient _client;
  bool _loading = true;
  String tempToken = "";
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  Future<void> getToken() async {
    String link =
        "https://agora-node-tokenserver.saugatthapa2.repl.co/access_token?channelName=${widget.channelName}";
    Response _response = await get(Uri.parse(link));
    Map data = jsonDecode(_response.body);
    setState(() {
      tempToken = data["token"];
      print("----------------------------" + tempToken);
    });

    _client = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
          appId: "2e434cbf455c4d6593dcafc2c52845d7",
          tempToken: tempToken,
          // channelName: widget.channelName,
          channelName: widget.channelName,
        ),
        enabledPermission: [
          Permission.camera,
          Permission.microphone,
        ]);

    _client.initialize();

    Future.delayed(Duration(seconds: 1))
        .then((value) => setState(() => _loading = false));
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  AgoraVideoViewer(
                    client: _client,
                    layoutType: Layout.floating,
                    showNumberOfUsers: true,
                  ),
                  AgoraVideoButtons(
                    client: _client,
                    autoHideButtons: true,
                    autoHideButtonTime: 10,
                    // extraButtons: [
                    //   FloatingActionButton(
                    //       backgroundColor: Colors.red,
                    //       child: Icon(Icons.call_end),
                    //       onPressed: () => _endMeating())
                    // ],
                    // enabledButtons: [
                    //   BuiltInButtons.toggleCamera,
                    //   BuiltInButtons.toggleMic,
                    //   BuiltInButtons.switchCamera,
                    // ],
                  ),
                ],
              ),
      ),
    );
  }

  // _endMeating() async {
  //   await _client.sessionController.endCall();
  //   Navigator.pop(context);
  // }

//   @override
//   void dispose() {
//     _client.sessionController.dispose();
//     super.dispose();
//   }
}
