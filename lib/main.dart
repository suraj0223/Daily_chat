import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './screens/main_screen.dart';
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

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        return snapshot.hasData
              ? MainScreen()
              : AuthScreen();
      },
    );
  }
}
