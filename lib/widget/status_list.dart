import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

class StatusList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Under Maintainance !'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF25d366),
        elevation: 10,
        child: Icon(Icons.camera_alt),
        onPressed: () {
          // open camera for addinf a status
        },
      ),
    );
  }
}
