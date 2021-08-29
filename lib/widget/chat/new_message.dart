import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
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
              icon: Icon(Icons.add),
              color: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Under Maintainance'),
                  duration: Duration(milliseconds: 300),
                ));
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
