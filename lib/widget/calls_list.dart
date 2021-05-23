import 'package:flutter/material.dart';
class CallsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Under Maintainance !')),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        backgroundColor: Color(0xFF25d366),
        child: Icon(Icons.phone),
        onPressed: () {
          // add a new call
        },
      ),
    );
  }
}
