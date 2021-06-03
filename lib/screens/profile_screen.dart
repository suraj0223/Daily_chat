import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static final String profileRoute = "/profileScreenRoute";

  final currentUsr = FirebaseAuth.instance.currentUser;

  Widget customTextFormField({String labeltext, String currentData}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          initialValue: currentData,
          decoration: new InputDecoration(
            labelText: labeltext,
            labelStyle: TextStyle(color: Colors.grey),
            errorStyle: TextStyle(color: Colors.red),
            counterStyle: TextStyle(color: Color(0xFF075e54)),
            fillColor: Colors.white,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(50.0),
              borderSide: new BorderSide(),
              gapPadding: 2,
            ),
          ),
          validator: (val) {
            if (val.length == 0) {
              return "Field can't be empty ";
            } else {
              return null;
            }
          },
          style: new TextStyle(fontFamily: "Poppins"),
          // onChanged: (value) {
          //   print('new value is $value');
          // },
          onFieldSubmitted: (value) {
            print('final value is $value');
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(currentUsr.uid)
              .snapshots(),
          builder: (context, usrSnapshot) {
            final usrdocs = usrSnapshot.hasData ? usrSnapshot.data : null;
            if (usrSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (usrSnapshot.hasData &&
                usrSnapshot.connectionState == ConnectionState.active) {
              var currentUserData = usrdocs.data();
              return Container(
                padding: EdgeInsets.only(top: 15, left: 40, right: 40),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Image(
                          height: 150,
                          width: 150,
                          image: AssetImage('assets/images/user.png'),
                        ),
                      ),
                      customTextFormField(
                          labeltext: 'Name',
                          currentData: currentUserData['username']),
                      customTextFormField(
                          labeltext: 'Email',
                          currentData: currentUserData['email']),
                      customTextFormField(
                          labeltext: 'Phone Number',
                          currentData: currentUserData['phonenumber']),
                      customTextFormField(
                          labeltext: 'Status',
                          currentData: currentUserData['status']),
                      customTextFormField(
                          labeltext: 'About',
                          currentData: currentUserData['about']),
                    ],
                  ),
                ),
              );
            }
            return Container();
          }),
    );
  }
}
