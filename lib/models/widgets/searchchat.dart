import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:textme/pages/chatdetail.dart';

class SearchChat extends StatefulWidget {
  const SearchChat({Key? key}) : super(key: key);

  @override
  _SearchChatState createState() => _SearchChatState();
}

class _SearchChatState extends State<SearchChat> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController search = TextEditingController();
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        titleSpacing: 0,
        title: new TextFormField(
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
            hintText: "Type your messege",
            hintStyle: new TextStyle(color: Colors.grey),
            fillColor: Colors.white,
            filled: true,
            contentPadding: const EdgeInsets.fromLTRB(13.0, -5.0, 0.0, -5.0),
            focusedBorder: new OutlineInputBorder(
                borderSide:
                    new BorderSide(width: 0.0000000001, color: Colors.black),
                borderRadius: new BorderRadius.circular(10.0)),
            enabledBorder: new OutlineInputBorder(
              borderSide:
                  new BorderSide(width: 0.0000000001, color: Colors.white),
              borderRadius: new BorderRadius.circular(10.0),
            ),
          ),
        ),
        actions: [
          new IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: new Icon(Icons.search),
          ),
        ],
      ),
      body: _isSearching
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: StreamBuilder<dynamic>(
                stream: _firestore
                    .collection("Users")
                    .doc(_auth.currentUser!.uid)
                    .collection("Favorites")
                    .where("name", isEqualTo: search)
                    .orderBy("time", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? new ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            return StreamBuilder<dynamic>(
                                stream: _firestore
                                    .collection("Users")
                                    .where(snapshot.data.docs[index]["id"])
                                    .snapshots(),
                                builder: (context, snapshots) {
                                  return snapshots.hasData
                                      ? new InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        new ChatDetail(
                                                            name: snapshot.data
                                                                    .docs[index]
                                                                ["name"],
                                                            userId: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ["id"],
                                                            profilePic: snapshots
                                                                    .data
                                                                    .docs[index]
                                                                [
                                                                "profilePic"])));
                                          },
                                          child: new Container(
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
                                                  new Row(
                                                    children: [
                                                      new Hero(
                                                        tag: snapshot.data
                                                            .docs[index]["id"],
                                                        child: new ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          child: snapshots
                                                                  .data
                                                                  .docs[index][
                                                                      "profilePic"]
                                                                  .isNotEmpty
                                                              ? new CachedNetworkImage(
                                                                  height: 49,
                                                                  width: 49,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  imageUrl: snapshots
                                                                          .data
                                                                          .docs[index]
                                                                      [
                                                                      "profilePic"],
                                                                  placeholder:
                                                                      (context,
                                                                          url) {
                                                                    return new Container(
                                                                      height:
                                                                          100,
                                                                      child:
                                                                          new Center(
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
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            new Text(
                                                              snapshot.data
                                                                          .docs[
                                                                      index]
                                                                  ["name"],
                                                              style: new TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800),
                                                            ),
                                                            new SizedBox(
                                                              height: 3.0,
                                                            ),
                                                            new Text(
                                                              "Last Messege",
                                                              style: new TextStyle(
                                                                  color: Colors
                                                                      .white60,
                                                                  fontSize:
                                                                      11.5),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      new Text(
                                                        DateTimeFormat.format(
                                                            snapshot
                                                                .data
                                                                .docs[index]
                                                                    ["time"]
                                                                .toDate(),
                                                            format: 'H:i'),
                                                        style: new TextStyle(
                                                            color:
                                                                Colors.white60,
                                                            fontSize: 11.5),
                                                      ),
                                                    ],
                                                  ),
                                                  new Divider()
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : new SpinKitFadingCircle(
                                          color: Color(0xFF2EF7F7));
                                });
                          },
                        )
                      : new SpinKitFadingCircle(color: Color(0xFF2EF7F7));
                },
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: StreamBuilder<dynamic>(
                stream: _firestore
                    .collection("Users")
                    .doc(_auth.currentUser!.uid)
                    .collection("Favorites")
                    .orderBy("time", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? new ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            return StreamBuilder<dynamic>(
                                stream: _firestore
                                    .collection("Users")
                                    .where(snapshot.data.docs[index]["id"])
                                    .snapshots(),
                                builder: (context, snapshots) {
                                  return snapshots.hasData
                                      ? new InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        new ChatDetail(
                                                            name: snapshot.data
                                                                    .docs[index]
                                                                ["name"],
                                                            userId: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ["id"],
                                                            profilePic: snapshots
                                                                    .data
                                                                    .docs[index]
                                                                [
                                                                "profilePic"])));
                                          },
                                          child: new Container(
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
                                                  new Row(
                                                    children: [
                                                      new Hero(
                                                        tag: snapshot.data
                                                            .docs[index]["id"],
                                                        child: new ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          child: snapshots
                                                                  .data
                                                                  .docs[index][
                                                                      "profilePic"]
                                                                  .isNotEmpty
                                                              ? new CachedNetworkImage(
                                                                  height: 49,
                                                                  width: 49,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  imageUrl: snapshots
                                                                          .data
                                                                          .docs[index]
                                                                      [
                                                                      "profilePic"],
                                                                  placeholder:
                                                                      (context,
                                                                          url) {
                                                                    return new Container(
                                                                      height:
                                                                          100,
                                                                      child:
                                                                          new Center(
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
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            new Text(
                                                              snapshot.data
                                                                          .docs[
                                                                      index]
                                                                  ["name"],
                                                              style: new TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800),
                                                            ),
                                                            new SizedBox(
                                                              height: 3.0,
                                                            ),
                                                            new Text(
                                                              "Last Messege",
                                                              style: new TextStyle(
                                                                  color: Colors
                                                                      .white60,
                                                                  fontSize:
                                                                      11.5),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      new Text(
                                                        DateTimeFormat.format(
                                                            snapshot
                                                                .data
                                                                .docs[index]
                                                                    ["time"]
                                                                .toDate(),
                                                            format: 'H:i'),
                                                        style: new TextStyle(
                                                            color:
                                                                Colors.white60,
                                                            fontSize: 11.5),
                                                      ),
                                                    ],
                                                  ),
                                                  new Divider()
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : new SpinKitFadingCircle(
                                          color: Color(0xFF2EF7F7));
                                });
                          },
                        )
                      : new SpinKitFadingCircle(color: Color(0xFF2EF7F7));
                },
              ),
            ),
    );
  }
}
