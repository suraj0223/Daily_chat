import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../screens/chat_screen.dart';
import '../widget/create_chatRoom/ChatRoomID.dart';

class SearchPeopleList extends StatelessWidget {
  final String username;
  final String email;
  final String userId;
  final String profileUrl;

  const SearchPeopleList(
      {this.username, this.email, this.userId, this.profileUrl});

  void sendMessage(BuildContext context, String userName) async {
    final user = FirebaseAuth.instance.currentUser;
    final myData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    List<String> users = [myData['username'], userName];

    // String _chatRoomId = ChatRoomId.getID(
    //   currentUser: myData['username'],
    //   anotherUser: userName,
    // );
    final _chatRoomId = ChatRoomId.getID(
      currentUser: user.uid,
      anotherUser: userId,
    );

// print("chatRoomId : $_chatRoomId \nUser1: ${myData['username']} \nUser2: $userName");

    FirebaseFirestore.instance.collection("chatRoom").doc(_chatRoomId).set({
      "users": users,
      "chatRoomId": _chatRoomId,
    }).catchError((e) {
      print(e);
      // show use a dialog box
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => ChatScreen(
          profileUrl: profileUrl,
          chatRoomId: _chatRoomId,
          anonymousUser: userName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: profileUrl != null
            ? NetworkImage(profileUrl)
            : AssetImage('assets/images/user.png'),
      ),
      title: Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(email),
      trailing: Container(
        padding: EdgeInsets.all(6),
        child: Text('Message'),
        decoration: BoxDecoration(
          color: Color(0xFF25d366),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
      onTap: () {
        sendMessage(context, username);
      },
    );
  }
}
