import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'dart:math';

class NewMessage extends StatefulWidget {
  final chatRoomId;
  NewMessage(
    this.chatRoomId,
  );
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final _textController = TextEditingController();

   Recording _recording = new Recording();
  bool _isRecording = false;
  Random random = new Random();
  TextEditingController _controller = new TextEditingController();
  final LocalFileSystem localFileSystem = LocalFileSystem();

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
    });
    setState(() {
      _textController.clear();
      _enteredMessage = '';
    });
  }

  _start() async {
    try {
      if (await AudioRecorder.hasPermissions) {
        if (_controller.text != null && _controller.text != "") {
          String path = _controller.text;
          if (!_controller.text.contains('/')) {
            io.Directory appDocDirectory =
                await getApplicationDocumentsDirectory();
            path = appDocDirectory.path + '/' + _controller.text;
          }
          print("Start recording: $path");
          await AudioRecorder.start(
              path: path, audioOutputFormat: AudioOutputFormat.AAC);
        } else {
          await AudioRecorder.start();
        }
        bool isRecording = await AudioRecorder.isRecording;
        setState(() {
          _recording = new Recording(duration: new Duration(), path: "");
          _isRecording = isRecording;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

   _stop() async {
    var recording = await AudioRecorder.stop();
    print("Stop recording: ${recording.path}");
    bool isRecording = await AudioRecorder.isRecording;
    File file = localFileSystem.file(recording.path);
    
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final String chRoomId = widget.chatRoomId;
    FirebaseFirestore.instance.collection("chatRoom/$chRoomId/chats").add({
      'voice note': file.readAsBytes(),
    });

    setState(() {
      _recording = recording;
      _isRecording = isRecording;
    });
    _controller.text = recording.path;
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
            IconButton(
              icon: Icon(Icons.mic),
              color: Colors.white,
              onPressed:  _isRecording ? _stop : _start
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
                  hintText: 'Type a message',
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
