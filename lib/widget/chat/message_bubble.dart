import 'package:flutter/material.dart';
class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String username;
  final Widget cwidget;
  const MessageBubble({this.message, this.isMe, this.username, this.cwidget});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: isMe? Alignment.centerRight : Alignment.centerLeft,
          decoration: BoxDecoration(
            color: isMe ? Color(0xFF10f099).withOpacity(0.5) : Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.only(
              topLeft: isMe ? Radius.circular(20) : Radius.circular(0),
              topRight: isMe ? Radius.circular(0) : Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          // width: MediaQuery.of(context).size.width*0.6,
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          margin: EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          child: cwidget
        ),
      ],
    );
  }
}
