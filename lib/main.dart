import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/screens/main_screen.dart';
import './screens/auth_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsApp',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      color: Color(0xFF075e54),
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Color(0xFF075e54),
        ),
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Color(0xFF25d366),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.hasData) {
            return MainScreen();
          }
          return AuthScreen();
        },
      ),
      // body: AuthScreen(),
    );
  }
}
