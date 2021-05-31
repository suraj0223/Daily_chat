import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/screens/auth_screen.dart';
import 'package:whatsapp/screens/search_screen.dart';
import '../widget/chats_list.dart';
import '../widget/status_list.dart';
import '../widget/calls_list.dart';

class MainScreen extends StatefulWidget {
  static final mainScreenRoute = '/mainScreenRoute';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF075e54),
          centerTitle: false,
          title: Text('WhatsApp'),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                child: Text(
                  'CHATS',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                  child: Text(
                'STATUS',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              Tab(
                  child: Text(
                'CALLS',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // add a new search screen
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchScreen()));
              },
            ),
            PopupMenuButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.green[700])),
              itemBuilder: (ctx) {
                return [
                  PopupMenuItem(
                    child: TextButton(
                      child: Text('New Chats'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchScreen()));
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: TextButton(
                      child: Text('Setting'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Under Maintainance'),
                          ),
                        );
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: TextButton(
                      child: Text('Logout'),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushNamed(context, AuthScreen.authRoute);
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
