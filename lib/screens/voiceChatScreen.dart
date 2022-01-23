import 'dart:async';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:whatsapp/constants/credential.dart';

class VoiceChatScreen extends StatefulWidget {
  final String channelName;
  final String profileUrl;
  final String anonymousUser;
  VoiceChatScreen(
      {@required this.channelName, this.profileUrl, this.anonymousUser});
  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<VoiceChatScreen> {
  static final _users = <int>[];
  bool muted = false;
  RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await _engine.enableWebSdkInteroperability(true);
    await _engine.setParameters(
        '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    await _engine.joinChannel(null, widget.channelName, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(APP_ID);
    // await _engine.enableVideo();
    //await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    //await _engine.setClientRole(widget.role);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(
        error: (code) {
          // setState(() {
          // });
        },
        joinChannelSuccess: (channel, uid, elapsed) {
          // setState(() {
          // });
        },
        leaveChannel: (stats) {
          setState(() {
            _users.clear();
          });
        },
        userJoined: (uid, elapsed) {
          setState(() {
            _users.add(uid);
          });
        },
        userOffline: (uid, elapsed) {
          setState(() {
            _users.remove(uid);
          });
        },
        firstRemoteVideoFrame: (uid, width, height, elapsed) {}));
  }

  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [
      RtcLocalView.SurfaceView(), // ??
    ];
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    return list;
  }

  /// Video layout wrapper
  Widget _viewRows() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.anonymousUser),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.pinkAccent.withOpacity(0.3)),
          padding: EdgeInsets.all(40),
          child: CircleAvatar(
            radius: 80,
              backgroundImage: widget.profileUrl != null
                  ? NetworkImage(widget.profileUrl)
                  : AssetImage('assets/images/user.png')),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          // shape: BoxShape.circle,
          color: Colors.green.withOpacity(0.3),
        ),
        width: MediaQuery.of(context).size.width,
        height: 150,
      ),
    );
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.blueGrey : Colors.blueAccent,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                elevation: 2.0,
                padding: const EdgeInsets.all(15.0),
                primary: Colors.red),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Stack(
            children: <Widget>[
              _viewRows(),
              _toolbar(),
            ],
          ),
        ),
      ),
    );
  }
}
