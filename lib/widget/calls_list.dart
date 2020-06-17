import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CallsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: 10,
        itemBuilder: (context, i) => ListTile(
          contentPadding: EdgeInsets.all(5),
          leading: CircleAvatar(
            backgroundImage: null,
          ),
          title: Text('Name of person '),
          subtitle: Text('${DateFormat.yMMMMEEEEd().format(DateTime.now() )}'),
          onTap: () {
            // open mobile call 
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        backgroundColor: Color(0xFF25d366),
        child: Icon(Icons.phone),
        onPressed: (){
          // add a new call 
        },
      ),
    );
  }
}