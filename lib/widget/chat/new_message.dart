import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
// import 'package:audioplayer/audioplayer.dart';

class NewMessage extends StatefulWidget {
  final chatRoomId;
  NewMessage(this.chatRoomId);
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final _textController = TextEditingController();

  ScrollController scrollController = ScrollController();
  bool isPlayingMsg = false, isRecording = false, isSending = false;

  void _sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final String chRoomId = widget.chatRoomId;
    FirebaseFirestore.instance.collection('chatRoom/$chRoomId/chats').add({
      'text': _enteredMessage,
      'createdBy': userData['username'],
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'type': 'text'
    });
    setState(() {
      _textController.clear();
      _enteredMessage = '';
    });
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      recordFilePath = await getFilePath();

      RecordMp3.instance.start(recordFilePath, (type) {
        setState(() {});
      });
    } else {}
    setState(() {});
  }

  void stopRecord() async {
    bool s = RecordMp3.instance.stop();
    if (s) {
      setState(() {
        isSending = true;
      });
      await uploadAudio();

      setState(() {
        isPlayingMsg = false;
      });
    }
  }

  String recordFilePath;

  // Future<void> play() async {
  //   if (recordFilePath != null && File(recordFilePath).existsSync()) {
  //     AudioPlayer audioPlayer = AudioPlayer();
  //     await audioPlayer.play(
  //       recordFilePath,
  //       isLocal: true,
  //     );
  //   }
  // }

  int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test_${i++}.mp3";
  }

  uploadAudio() {
    FirebaseStorage.instance
        .ref()
        .child(
            "AudioMessages/audio${DateTime.now().millisecondsSinceEpoch.toString()}.jpg")
        .putFile(File(recordFilePath))
        .then((value) async {
      print('uploaded to Firestore');
      var audioURL = await value.ref.getDownloadURL();
      String strVal = audioURL.toString();
      await sendAudioMsg(strVal);
    }).catchError((e) {
      print(e);
    });
  }

  sendAudioMsg(String audioMsg) async {
    if (audioMsg.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final String chRoomId = widget.chatRoomId;
      await FirebaseFirestore.instance
          .collection('chatRoom/$chRoomId/chats')
          .add({
        'audio': audioMsg,
        'createdBy': userData['username'],
        'createdAt': Timestamp.now(),
        'userId': user.uid,
        'type': 'audio'
      }).then(
        (value) => setState(
          () {
            isSending = false;
          },
        ),
      );

      scrollController.animateTo(0.0,
          duration: Duration(milliseconds: 100), curve: Curves.bounceInOut);
    } else {
      print("Audio message error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: Container(
                margin: EdgeInsets.all(5),
                child: Icon(
                  Icons.mic,
                  size: 30,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(5),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.green),
              ),
              onLongPress: () {
                startRecord();
                setState(() {
                  isRecording = true;
                });
              },
              onLongPressEnd: (details) {
                stopRecord();
                setState(() {
                  isRecording = false;
                });
              },
            ),
            Expanded(
              child: TextField(
                controller: _textController,
                minLines: 1,
                maxLines: null,
                style: TextStyle(color: Colors.white, fontSize: 20),
                showCursor: true,
                cursorHeight: 30,
                cursorWidth: 4,
                cursorColor: Color(0xFF075e54),
                toolbarOptions: ToolbarOptions(
                  copy: true,
                  cut: true,
                  paste: true,
                  selectAll: true,
                ),
                decoration: InputDecoration(
                  hintText: isRecording ? 'Recording...' : 'Type a message',
                  hintStyle: TextStyle(
                      fontSize: 20, color: Colors.white.withOpacity(0.5)),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _enteredMessage = value;
                  });
                },
              ),
            ),
            FloatingActionButton(
              child: Icon(Icons.send),
              backgroundColor: Color(0xFF25d366),
              splashColor: Colors.green[200],
              onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
            ),
          ],
        ));
  }
}
