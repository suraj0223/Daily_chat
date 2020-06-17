import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String username;
  final Key key;

  const MessageBubble({this.message, this.isMe, this.key, this.username});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: isMe ? Color(0xFF10f099) : Colors.grey[200],
            borderRadius: BorderRadius.only(
              topLeft: isMe ? Radius.circular(20) : Radius.circular(0),
              topRight: isMe ? Radius.circular(0) : Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          width: MediaQuery.of(context).size.width * 0.58,
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          margin: EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          child: Column(
            children: <Widget>[
              Text(
                username,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                message,
                style: TextStyle(color: Colors.black),
                textAlign: isMe ? TextAlign.end : TextAlign.start,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
