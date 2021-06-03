import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/chat_screen.dart';
import '../widget/create_chatRoom/ChatRoomID.dart';
import '../screens/search_screen.dart';

class ChatsList extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (ctx, chatSnapshot) {
            final List<DocumentSnapshot> chatDocs =
                chatSnapshot.hasData ? chatSnapshot.data.docs : null;
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (chatSnapshot.hasData &&
                chatSnapshot.connectionState == ConnectionState.active) {
              return chatDocs.length != 0
                  ? ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 3.0),
                      physics: ClampingScrollPhysics(),
                      children: chatDocs.map((doc) {
                        return doc.id != FirebaseAuth.instance.currentUser.uid
                            ? ListTile(
                                leading: CircleAvatar(
                                  foregroundColor: Colors.transparent,
                                  backgroundImage: AssetImage(
                                    "assets/images/user.png",
                                  ),
                                  radius: 25.0,
                                ),
                                title: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(doc['username']),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(doc['email']),
                                ),
                                onTap: () async {
                                  // when you hit then go to that chatroom and show that
                                  // conversations between two
                                  // final user = FirebaseAuth.instance.currentUser;

                                  final userData = await FirebaseFirestore
                                      .instance
                                      .collection('users')
                                      .doc(user.uid)
                                      .get();

                                  final _chatRoomId = ChatRoomId.getID(
                                      currentUser: user.uid,
                                      anotherUser: doc.id);

                                  // print("Current user : " + user.uid);
                                  // print("another user : " + doc.id);

                                  FirebaseFirestore.instance
                                      .collection("chatRoom")
                                      .doc(_chatRoomId)
                                      .set({
                                    "users": [
                                      doc['username'],
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
                                        anonymousUser: doc['username'],
                                        chatRoomId: _chatRoomId,
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container();
                      }).toList(),
                    )
                  : Center(
                      child: Text('No Users available right now!'),
                    );
            } else if (chatSnapshot.hasError) {
              return Center(
                child: Icon(
                  Icons.error,
                  size: 35,
                  color: Colors.yellow,
                ),
              );
            } else {
              return Center(child: Text('Unexpected error'));
            }
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
