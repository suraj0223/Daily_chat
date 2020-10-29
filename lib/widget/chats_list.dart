import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/chat_screen.dart';
import '../widget/create_chatRoom/ChatRoomID.dart';
import '../screens/search_screen.dart';

class ChatsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (ctx, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatDocs = chatSnapshot.data.documents;
            return ListView.builder(
              itemCount: chatDocs.length,
              itemBuilder: (ctx, index) => Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Color(0xFF25d366),
                      // wanna add padding then most welcome
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(chatDocs[index]['username']),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(chatDocs[index]['email']),
                    ),
                    onTap: () async {
                      // when you hit then go to that chatroom and show that
                      // conversations between two
                      final user = FirebaseAuth.instance.currentUser;
                      final userData = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .get();
                      final _chatRoomId = ChatRoomId.getID(
                          chatDocs[index]['username'], userData['username']);

                      print("chatRoomId : $_chatRoomId \nUser1: ${chatDocs[index]['username']} \nUser2: ${userData['username']}");
                     
                       FirebaseFirestore.instance
                            .collection("chatRoom")
                            .doc(_chatRoomId)
                            .set({
                          "users": [
                            chatDocs[index]['username'],
                            userData['username'],
                          ],
                          "chatRoomId": _chatRoomId,
                        }).catchError((e) {
                          print(e);
                          // show use a dialog box
                        });
              
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => ChatScreen(
                            anonymousUser: chatDocs[index]['username'],
                            chatId: _chatRoomId,
                          ),
                        ),
                      );
                    },
                  ),
                  Divider(
                    indent: 70,
                    endIndent: 25,
                    color: Colors.black87,
                  )
                ],
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF25d366),
        elevation: 10,
        child: Icon(Icons.chat),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
          // Add a new chat to the top
        },
      ),
    );
  }
}
