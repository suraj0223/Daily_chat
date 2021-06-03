import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/main_screen.dart';
import '../widget/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  static final authRoute = "/AuthRoute";
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  void _submitAuthForm(
    String username,
    String email,
    String password,
    String phoneNumber,
    String status,
    String about,
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
            .then((value) => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainScreen()),
                (route) => false));
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
          'phonenumber': '+91' + phoneNumber,
          'status': status,
          'about': about
        });

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
            (route) => false);
      }
    } on PlatformException catch (err) {
      var message = 'An Error occured, Please check your credentials!';

      if (err.message != null) {
        message = err.message;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        elevation: 30,
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: TextStyle(color: Theme.of(context).errorColor),
        ),
        backgroundColor: Colors.black54,
      ));
    } catch (error) {
      showDialog(
          context: context,
          builder: (ctx) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.greenAccent.withOpacity(0.4)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.admin_panel_settings_outlined,
                        size: 120,
                      ),
                      Text('Please Enter the correct Credentials!'),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Okay'))
                    ],
                  )),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AuthForm(_submitAuthForm),
    );
  }
}
