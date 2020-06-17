import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/screens/auth_screen.dart';
import 'package:whatsapp/screens/search_screen.dart';
import '../widget/chats_list.dart';
import '../widget/status_list.dart';
import '../widget/calls_list.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF075e54),
          centerTitle: false,
          title: Text('WhatsApp'),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(child: Icon(Icons.camera_alt)),
              Tab(
                child: Text('CHATS'),
              ),
              Tab(
                child: Text('STATUS'),
              ),
              Tab(
                child: Text('CALLS'),
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  // add a new search screen
                  Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
                }),
            PopupMenuButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.green[700])),
              itemBuilder: (ctx) {
                return [
                  PopupMenuItem(
                    child: FlatButton(
                      child: Text('New Chats'),
                      onPressed: () {
                        Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: FlatButton(
                      child: Text('Setting'),
                      onPressed: () {},
                    ),
                  ),
                  PopupMenuItem(
                    child: FlatButton(
                      child: Text('Logout'),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AuthScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ];
              },
            )
          ],
        ),
        body: TabBarView(
          children: [
            //for camera
            Container(),
            //for chats list
            ChatsList(),
            //for status list
            StatusList(),
            //for calls list
            CallsList(),
          ],
        ),
      ),
    );
  }
}
