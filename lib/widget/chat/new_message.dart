import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


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
  
  void _sendMessage() async {
    final user = await FirebaseAuth.instance.currentUser();
    final userData = await Firestore.instance
                    .collection('users')
                    .document(user.uid)
                    .get();
    final String chRoomId = widget.chatRoomId;
    Firestore.instance.collection('chatRoom/$chRoomId/chats').add({
      'text': _enteredMessage,
      'createdBy': userData['username'],
      'createdAt': Timestamp.now(),
      'userId': user.uid,
    });
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      margin: EdgeInsets.only(
        bottom: 20,
        left: 10,
        right: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.black54,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textController,
              minLines: 1,
              maxLines: 10,
              cursorColor: Colors.blue,
              style: TextStyle(color: Colors.white, height: 2.0),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                hintText: 'Type a message',
                border: InputBorder.none,
                suffixIcon: FloatingActionButton(
                  child: Icon(Icons.send),
                  onPressed:
                      _enteredMessage.trim().isEmpty ? null : _sendMessage,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
