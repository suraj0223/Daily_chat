import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp/widget/chat/message_bubble.dart';


class Messages extends StatelessWidget {
  final String chatRoomId;

  Messages(
    this.chatRoomId,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.getRedirectResult(),
        builder: (ctx, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chatRoom/$chatRoomId/chats')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (ctx, chatSnapshot) {
                if (chatSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final chatDocs = chatSnapshot.data.documents;
                return ListView.builder(
                  reverse: true,
                  itemCount: chatDocs.length,
                  itemBuilder: (ctx, index) => MessageBubble(
                    message: chatDocs[index]['text'],
                    username: chatDocs[index]['createdBy'],
                    isMe: chatDocs[index]['userId'] == futureSnapshot.data.uid,
                    key: ValueKey(chatDocs[index].documentID),
                  ),
                );
              });
        });
  }
}
