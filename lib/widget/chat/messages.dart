import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp/widget/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  final String chatRoomId;
  Messages(this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chatRoom/$chatRoomId/chats')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshot) {
          final List<DocumentSnapshot> chatDocs =
              chatSnapshot.hasData ? chatSnapshot.data.docs : null;

          if (chatSnapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else if (chatSnapshot.hasData &&
              chatSnapshot.connectionState == ConnectionState.active)
            return ListView(
                reverse: true,
                children: chatDocs.map((message) {
                  return MessageBubble(
                    message: message['text'],
                    username: message['createdBy'],
                    isMe: message['userId'] ==
                        FirebaseAuth.instance.currentUser.uid,
                    // key: ValueKey(message.documentID),
                  );
                }).toList());
          return Container();
        });
  }
}
