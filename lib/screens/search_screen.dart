import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/widget/search_peoplelist.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _textEditingController = TextEditingController();

  var searchedUserData;
  var listData;

  Future<void> _onSearch() async {
    searchedUserData = await Firestore.instance
        .collection("users")
        .where('username', isEqualTo: _textEditingController.text)
        .getDocuments();

    setState(() {
      listData = searchedUserData;
    });
    FocusScope.of(context).unfocus();
  }

  Widget displaySearchData() {
    return listData == null
        ? Center(
            child: Text('No User Found'),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: listData.documents.length,
            itemBuilder: (ctx, index) {
              return Card(
                elevation: 10,
                child: SearchPeopleList(
                  email: listData.documents[index].data['email'],
                  username: listData.documents[index].data['username'],
                ),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search People'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                        hintText: 'Search User by name ',
                        hintStyle: TextStyle()),
                  )),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.search,
                        size: 35,
                      ),
                      onPressed: _onSearch,
                    ),
                  ),
                ],
              ),
            ),
            displaySearchData(),
          ],
        ),
      ),
    );
  }
}
