import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/widget/search_peoplelist.dart';

class SearchScreen extends StatefulWidget {
  static final searchScreenRoute = '/searchScreenRote';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _textEditingController = TextEditingController();

  var searchedUserData;
  var listData;

  Future<void> _onSearch() async {
    searchedUserData = await FirebaseFirestore.instance
        .collection("users")
        .where('username', isEqualTo: _textEditingController.text)
        .get();

    setState(() {
      listData = searchedUserData;
    });
    
    FocusScope.of(context).unfocus();
  }

  Widget displaySearchData(BuildContext ctx) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: _textEditingController.text)
          .snapshots(),
      builder: (ctx, searchSnap) {
        final List<DocumentSnapshot> seachdoc =
            searchSnap.hasData ? searchSnap.data.docs : null;
        if (searchSnap.hasData &&
            searchSnap.connectionState == ConnectionState.active) {
          return seachdoc.length == 0 ? Center(child: Text('No person with this name exist!')) : ListView(
            children: seachdoc.map((querry) {
              return SearchPeopleList(
                email: querry['email'],
                username: querry['username'],
              );
            }).toList(),
          );
        } else if (searchSnap.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (!searchSnap.hasData) return Text('No User found');
        return Text('Error Occurred!');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search People')),
      body: Column(
        children: <Widget>[
          Flexible(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              padding: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: TextField(
                style: TextStyle(color: Colors.white, fontSize: 20),
                showCursor: true,
                cursorHeight: 30,
                cursorWidth: 4,
                cursorColor: Color(0xFF075e54),
                toolbarOptions: ToolbarOptions(
                  copy: true,
                  cut: true,
                  paste: true,
                  selectAll: true,
                ),
                decoration: InputDecoration(
                    hintText: 'Search User by name',
                    hintStyle: TextStyle(
                        fontSize: 20, color: Colors.white.withOpacity(0.5)),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                        icon: Icon(Icons.search), onPressed: _onSearch)),
                controller: _textEditingController,
              ),
            ),
          ),
          Flexible(child: displaySearchData(context)),
        ],
      ),
    );
  }
}
