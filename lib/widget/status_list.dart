import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatusList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: 10,
        itemBuilder: (context, i) => ListTile(
          contentPadding: EdgeInsets.all(5),
          leading: CircleAvatar(
            // image of the person
            backgroundImage: null,
          ),
          title: Text('Name of clients chat '),
          // add datetime now to status time from firebase 
          subtitle: Text('${DateFormat.yMMMMEEEEd().format(DateTime.now() )}'),
          onTap: () {
            // go to private chat screen
          },
        ),
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
