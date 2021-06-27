import 'package:flutter/material.dart';
import 'package:textme/models/widgets/searchusers.dart';
import 'package:textme/models/widgets/users.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController search = TextEditingController();
  bool _isSearching = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        titleSpacing: 0,
        title: _isSearching
            ? new TextFormField(
                onChanged: (value) {
                  setState(() {});
                },
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Type your messege!";
                  }
                },
                controller: search,
                cursorHeight: 22.0,
                decoration: new InputDecoration(
                  hintText: "Search",
                  hintStyle: new TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding:
                      const EdgeInsets.fromLTRB(13.0, -5.0, 0.0, -5.0),
                  focusedBorder: new OutlineInputBorder(
                      borderSide: new BorderSide(
                          width: 0.0000000001, color: Colors.black),
                      borderRadius: new BorderRadius.circular(10.0)),
                  enabledBorder: new OutlineInputBorder(
                    borderSide: new BorderSide(
                        width: 0.0000000001, color: Colors.white),
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                ),
              )
            : new Text("Search"),
        actions: [
          new IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (_isSearching) {
                  search.clear();
                }
              });
            },
            icon: new Icon(Icons.search),
          ),
        ],
      ),
      body: new SafeArea(
        child: _isSearching
            ? new SearchUser(
                search: search.text,
              )
            : Users(),
      ),
    );
  }
}
