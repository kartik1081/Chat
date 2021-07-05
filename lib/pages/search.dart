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
      appBar: AppBar(
        titleSpacing: 0,
        title: _isSearching
            ? TextFormField(
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
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding:
                      const EdgeInsets.fromLTRB(13.0, -5.0, 0.0, -5.0),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 0.0000000001, color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0)),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 0.0000000001, color: Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              )
            : Text("Search"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (_isSearching) {
                  search.clear();
                }
              });
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: _isSearching
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: StreamBuilder<dynamic>(
                  stream: _firestore
                      .collection("Users")
                      .where("name", isEqualTo: search.text)
                      // .orderBy("time", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatDetail(
                                        name: snapshot.data.docs[index]["name"],
                                        userId: snapshot.data.docs[index]["id"],
                                        profilePic: snapshot.data.docs[index]
                                            ["profilePic"],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: snapshot.data.docs[index]["id"] !=
                                          _auth.currentUser!.uid
                                      ? 75.0
                                      : 0.0,
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0, top: 10.0),
                                    child: TweenAnimationBuilder(
                                      duration: Duration(seconds: 4),
                                      tween:
                                          Tween<double>(begin: 400.0, end: 0),
                                      builder: (context, double value, child) {
                                        return Container(
                                          margin: EdgeInsets.only(left: value),
                                          child: child,
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Hero(
                                            tag: snapshot.data.docs[index]
                                                ["id"],
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: snapshot
                                                      .data
                                                      .docs[index]["profilePic"]
                                                      .isNotEmpty
                                                  ? CachedNetworkImage(
                                                      height: 49,
                                                      width: 49,
                                                      fit: BoxFit.cover,
                                                      imageUrl: snapshot
                                                              .data.docs[index]
                                                          ["profilePic"],
                                                      placeholder:
                                                          (context, url) {
                                                        return Container(
                                                          height: 100,
                                                          child: Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  : Image(
                                                      image: AssetImage(
                                                          "assets/avatar.png"),
                                                      height: 49,
                                                      width: 49,
                                                    ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "${snapshot.data.docs[index]["name"]}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              await _firestore
                                                  .collection("Users")
                                                  .doc(_auth.currentUser!.uid)
                                                  .collection("Favorites")
                                                  .doc(snapshot.data.docs[index]
                                                      ["id"])
                                                  .set({
                                                "name": snapshot
                                                    .data.docs[index]["name"],
                                                "profilePic": snapshot.data
                                                    .docs[index]["profilePic"],
                                                "time": DateTime.now(),
                                                "id": snapshot.data.docs[index]
                                                    ["id"],
                                              });
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              child: Container(
                                                width: 100,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    color: Color(0xFF1D1A2B)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "add",
                                                      style: TextStyle(
                                                          color: Colors.green),
                                                    ),
                                                    Icon(Icons.add,
                                                        color: Colors.green),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : SpinKitFadingCircle(color: Color(0xFF2EF7F7));
                  },
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: StreamBuilder<dynamic>(
                  stream: _firestore
                      .collection("Users")
                      // .orderBy("time", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? StreamBuilder<dynamic>(
                            stream: _firestore
                                .collection("Users")
                                .doc(_auth.currentUser!.uid)
                                .collection("Favorites")
                                .where("id")
                                .snapshots(),
                            builder: (context, snapshots) {
                              return snapshots.hasData
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: snapshot.data.docs.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatDetail(
                                                  name: snapshot
                                                      .data.docs[index]["name"],
                                                  userId: snapshot
                                                      .data.docs[index]["id"],
                                                  profilePic:
                                                      snapshot.data.docs[index]
                                                          ["profilePic"],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: snapshot.data.docs[index]
                                                        ["id"] !=
                                                    _auth.currentUser!.uid
                                                ? 75.0
                                                : 0.0,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0,
                                                  right: 15.0,
                                                  top: 10.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Hero(
                                                        tag: snapshot.data
                                                            .docs[index]["id"],
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          child: snapshot
                                                                  .data
                                                                  .docs[index][
                                                                      "profilePic"]
                                                                  .isNotEmpty
                                                              ? CachedNetworkImage(
                                                                  height: 49,
                                                                  width: 49,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  imageUrl: snapshot
                                                                          .data
                                                                          .docs[index]
                                                                      [
                                                                      "profilePic"],
                                                                  placeholder:
                                                                      (context,
                                                                          url) {
                                                                    return Container(
                                                                      height:
                                                                          100,
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            CircularProgressIndicator(),
                                                                      ),
                                                                    );
                                                                  },
                                                                )
                                                              : Image(
                                                                  image: AssetImage(
                                                                      "assets/avatar.png"),
                                                                  height: 49,
                                                                  width: 49,
                                                                ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10.0,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          "${snapshot.data.docs[index]["name"]}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          await _firestore
                                                              .collection(
                                                                  "Users")
                                                              .doc(_auth
                                                                  .currentUser!
                                                                  .uid)
                                                              .collection(
                                                                  "Favorites")
                                                              .doc(snapshot.data
                                                                      .docs[
                                                                  index]["id"])
                                                              .set({
                                                            "name": snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ["name"],
                                                            "profilePic": snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ["profilePic"],
                                                            "time":
                                                                DateTime.now(),
                                                            "id": snapshot.data
                                                                    .docs[index]
                                                                ["id"],
                                                          });
                                                        },
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                          child: Container(
                                                            width: 100,
                                                            height: 40,
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: Color(
                                                                        0xFF1D1A2B)),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  "add",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .green),
                                                                ),
                                                                Icon(Icons.add,
                                                                    color: Colors
                                                                        .green),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Divider()
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : SpinKitFadingCircle(
                                      color: Color(0xFF2EF7F7));
                            })
                        : SpinKitFadingCircle(color: Color(0xFF2EF7F7));
                  },
                ),
              ),
      ),
    );
  }
}
