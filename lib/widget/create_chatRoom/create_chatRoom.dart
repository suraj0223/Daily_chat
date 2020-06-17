// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class CreateChatRoom extends StatelessWidget {
//   String currentUser;
//   String secondUser;
//   CreateChatRoom({
//     this.currentUser,
//     this.secondUser,
//   });

//   createChatRoomId() async {
//     final currentUser = await FirebaseAuth.instance.currentUser();
//     final userData = await Firestore.instance
//         .collection('users')
//         .document(currentUser.uid)
//         .get();
//     if (userData['username'].substring(0, 1).codeUnitAt(0) >
//         secondUser.substring(0, 1).codeUnitAt(0)) {
//       return "$secondUser\_$userData['username']";
//     } else {
//       return "$userData['username']\_$secondUser";
//     }
//   }

//   void goToChatScreen() {
    
//     final usersList = Firestore.instance.collection('ChatRoom').where(createChatRoomId(), )

//   }


//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
