import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:whatsapp/screens/chat_screen.dart';
import 'package:whatsapp/screens/profile_screen.dart';
import 'package:whatsapp/screens/search_screen.dart';
import './screens/main_screen.dart';
import './screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      routes: {
        AuthScreen.authRoute: (ctx) => AuthScreen(),
        MainScreen.mainScreenRoute: (ctx) => MainScreen(),
        ChatScreen.chatScreenRoute: (ctx) => ChatScreen(),
        SearchScreen.searchScreenRoute: (ctx) => SearchScreen(),
        ProfileScreen.profileRoute: (ctx) => ProfileScreen(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser != null
        ? MainScreen()
        : AuthScreen();
  }
}
