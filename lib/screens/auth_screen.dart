import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/main_screen.dart';
import '../widget/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  void _submitAuthForm(
    String email,
    String password,
    String username,
    bool islogin,
    BuildContext context,
  ) async {
    dynamic authResult;
    try {
      if (islogin) {
        authResult = await _auth
            .signInWithEmailAndPassword(
              email: email,
              password: password,
            )
            .then(
              (value) => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(),
                ),
              ),
            );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user.uid)
            .set({
          'username': username,
          'email': email,
        });

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      }
    } on PlatformException catch (err) {
      var message = 'An Error occured, Please check your credentials!';

      if (err.message != null) {
        message = err.message;
      }

      Scaffold.of(context).showSnackBar(
        SnackBar(
          elevation: 30,
          behavior: SnackBarBehavior.floating,
          content: Text(
            message,
            style: TextStyle(color: Theme.of(context).errorColor),
          ),
          backgroundColor: Colors.black54,
        ),
      );
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthForm(_submitAuthForm),
    );
  }
}
