import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'chatdetail.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController search = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
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
            ? new Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: new StreamBuilder<dynamic>(
                  stream: _firestore
                      .collection("Users")
                      .where("name", isEqualTo: search.text)
                      // .orderBy("time", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? new ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              return new InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => new ChatDetail(
                                        name: snapshot.data.docs[index]["name"],
                                        userId: snapshot.data.docs[index]["id"],
                                        profilePic: snapshot.data.docs[index]
                                            ["profilePic"],
                                      ),
                                    ),
                                  );
                                },
                                child: new Container(
                                  height: snapshot.data.docs[index]["id"] !=
                                          _auth.currentUser!.uid
                                      ? 75.0
                                      : 0.0,
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0, top: 10.0),
                                    child: Column(
                                      children: [
                                        new Row(
                                          children: [
                                            new Hero(
                                              tag: snapshot.data.docs[index]
                                                  ["id"],
                                              child: new ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: snapshot
                                                        .data
                                                        .docs[index]
                                                            ["profilePic"]
                                                        .isNotEmpty
                                                    ? new CachedNetworkImage(
                                                        height: 49,
                                                        width: 49,
                                                        fit: BoxFit.cover,
                                                        imageUrl: snapshot.data
                                                                .docs[index]
                                                            ["profilePic"],
                                                        placeholder:
                                                            (context, url) {
                                                          return new Container(
                                                            height: 100,
                                                            child: new Center(
                                                              child:
                                                                  new CircularProgressIndicator(),
                                                            ),
                                                          );
                                                        },
                                                      )
                                                    : new Image(
                                                        image: AssetImage(
                                                            "assets/avatar.png"),
                                                        height: 49,
                                                        width: 49,
                                                      ),
                                              ),
                                            ),
                                            new SizedBox(
                                              width: 10.0,
                                            ),
                                            new Expanded(
                                              child: new Text(
                                                "${snapshot.data.docs[index]["name"]}",
                                                style: new TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                            ),
                                            new InkWell(
                                              onTap: () async {
                                                await _firestore
                                                    .collection("Users")
                                                    .doc(_auth.currentUser!.uid)
                                                    .collection("Favorites")
                                                    .doc(snapshot
                                                        .data.docs[index]["id"])
                                                    .set({
                                                  "name": snapshot
                                                      .data.docs[index]["name"],
                                                  "profilePic":
                                                      snapshot.data.docs[index]
                                                          ["profilePic"],
                                                  "time": DateTime.now(),
                                                  "id": snapshot
                                                      .data.docs[index]["id"],
                                                });
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                child: new Container(
                                                  width: 100,
                                                  height: 40,
                                                  decoration: new BoxDecoration(
                                                      color: Color(0xFF1D1A2B)),
                                                  child: new Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      new Text(
                                                        "add",
                                                        style: new TextStyle(
                                                            color:
                                                                Colors.green),
                                                      ),
                                                      new Icon(Icons.add,
                                                          color: Colors.green),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        new Divider()
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : new SpinKitFadingCircle(color: Color(0xFF2EF7F7));
                  },
                ),
              )
            : new Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: new StreamBuilder<dynamic>(
                  stream: _firestore
                      .collection("Users")
                      // .orderBy("time", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? new ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              return new InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => new ChatDetail(
                                        name: snapshot.data.docs[index]["name"],
                                        userId: snapshot.data.docs[index]["id"],
                                        profilePic: snapshot.data.docs[index]
                                            ["profilePic"],
                                      ),
                                    ),
                                  );
                                },
                                child: new Container(
                                  height: snapshot.data.docs[index]["id"] !=
                                          _auth.currentUser!.uid
                                      ? 75.0
                                      : 0.0,
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0, top: 10.0),
                                    child: Column(
                                      children: [
                                        new Row(
                                          children: [
                                            new Hero(
                                              tag: snapshot.data.docs[index]
                                                  ["id"],
                                              child: new ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: snapshot
                                                        .data
                                                        .docs[index]
                                                            ["profilePic"]
                                                        .isNotEmpty
                                                    ? new CachedNetworkImage(
                                                        height: 49,
                                                        width: 49,
                                                        fit: BoxFit.cover,
                                                        imageUrl: snapshot.data
                                                                .docs[index]
                                                            ["profilePic"],
                                                        placeholder:
                                                            (context, url) {
                                                          return new Container(
                                                            height: 100,
                                                            child: new Center(
                                                              child:
                                                                  new CircularProgressIndicator(),
                                                            ),
                                                          );
                                                        },
                                                      )
                                                    : new Image(
                                                        image: AssetImage(
                                                            "assets/avatar.png"),
                                                        height: 49,
                                                        width: 49,
                                                      ),
                                              ),
                                            ),
                                            new SizedBox(
                                              width: 10.0,
                                            ),
                                            new Expanded(
                                              child: new Text(
                                                "${snapshot.data.docs[index]["name"]}",
                                                style: new TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                            ),
                                            new InkWell(
                                              onTap: () async {
                                                await _firestore
                                                    .collection("Users")
                                                    .doc(_auth.currentUser!.uid)
                                                    .collection("Favorites")
                                                    .doc(snapshot
                                                        .data.docs[index]["id"])
                                                    .set({
                                                  "name": snapshot
                                                      .data.docs[index]["name"],
                                                  "profilePic":
                                                      snapshot.data.docs[index]
                                                          ["profilePic"],
                                                  "time": DateTime.now(),
                                                  "id": snapshot
                                                      .data.docs[index]["id"],
                                                });
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                child: new Container(
                                                  width: 100,
                                                  height: 40,
                                                  decoration: new BoxDecoration(
                                                      color: Color(0xFF1D1A2B)),
                                                  child: new Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      new Text(
                                                        "add",
                                                        style: new TextStyle(
                                                            color:
                                                                Colors.green),
                                                      ),
                                                      new Icon(Icons.add,
                                                          color: Colors.green),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        new Divider()
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : new SpinKitFadingCircle(color: Color(0xFF2EF7F7));
                  },
                ),
              ),
      ),
    );
  }
}
