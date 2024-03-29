import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'chatdetail.dart';

class AddFavorite extends StatefulWidget {
  const AddFavorite({Key? key}) : super(key: key);

  @override
  _AddFavoriteState createState() => _AddFavoriteState();
}

class _AddFavoriteState extends State<AddFavorite> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Favorites"),
          actions: [],
        ),
        body: Container(
          child: StreamBuilder(
            builder: (context, snapshot) {
              return Container(
                child: StreamBuilder<dynamic>(
                  stream: _firestore
                      .collection("Users")
                      .doc(_auth.currentUser!.uid)
                      .collection("ChatWith")
                      .orderBy("time", descending: true)
                      .snapshots(),
                  builder: (context, snapshot0) {
                    if (snapshot0.hasData) {
                      return snapshot0.data.docs.length != 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot0.data.docs.length,
                              itemBuilder: (context, index) {
                                return StreamBuilder<dynamic>(
                                  stream: _firestore
                                      .collection("Users")
                                      .doc(snapshot0.data.docs[index]["id"])
                                      .snapshots(),
                                  builder: (context, snapshot1) {
                                    return snapshot1.hasData
                                        ? InkWell(
                                            onLongPress: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                        title: Text("Alert"),
                                                        content: Text(
                                                            "Want to remove from chatlist?"),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                            child:
                                                                Text("cancle"),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                              _firestore
                                                                  .collection(
                                                                      "Users")
                                                                  .doc(_auth
                                                                      .currentUser!
                                                                      .uid)
                                                                  .collection(
                                                                      "ChatWith")
                                                                  .doc(snapshot1
                                                                          .data[
                                                                      "id"])
                                                                  .delete();
                                                            },
                                                            child: Text("ok"),
                                                          ),
                                                        ],
                                                      ));
                                            },
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatDetail(
                                                    name:
                                                        snapshot1.data["name"],
                                                    userId:
                                                        snapshot1.data["id"],
                                                    group: false,
                                                    profilePic: snapshot1
                                                        .data["profilePic"],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: snapshot1.data["id"] !=
                                                      _auth.currentUser!.uid
                                                  ? 80.0
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
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          child: snapshot1
                                                                  .data[
                                                                      "profilePic"]
                                                                  .isNotEmpty
                                                              ? CachedNetworkImage(
                                                                  height: 49,
                                                                  width: 49,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  imageUrl: snapshot1
                                                                          .data[
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
                                                        SizedBox(
                                                          width: 10.0,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            snapshot1
                                                                .data["name"],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800),
                                                          ),
                                                        ),
                                                        StreamBuilder<dynamic>(
                                                            stream: _firestore
                                                                .collection(
                                                                    "Users")
                                                                .doc(_auth
                                                                    .currentUser!
                                                                    .uid)
                                                                .collection(
                                                                    "ChatWith")
                                                                .doc(snapshot1
                                                                    .data["id"])
                                                                .snapshots(),
                                                            builder: (context,
                                                                snapshot) {
                                                              return snapshot
                                                                      .hasData
                                                                  ? IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        _firestore
                                                                            .collection(
                                                                                "Users")
                                                                            .doc(_auth
                                                                                .currentUser!.uid)
                                                                            .collection(
                                                                                "ChatWith")
                                                                            .doc(snapshot1.data[
                                                                                "id"])
                                                                            .update({
                                                                          "favorite": snapshot.data["favorite"]
                                                                              ? false
                                                                              : true
                                                                        }).whenComplete(() {});
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .favorite,
                                                                        color: snapshot.data["favorite"]
                                                                            ? Colors.red
                                                                            : Colors.grey,
                                                                      ))
                                                                  : Container();
                                                            })
                                                      ],
                                                    ),
                                                    Divider()
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 4.0, horizontal: 8.0),
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color: Color(0xFF31444B),
                                            ),
                                          );
                                  },
                                );
                              },
                            )
                          : Center(
                              child: Text(
                                "Add user for chatting",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                            );
                    } else {
                      return SpinKitFadingCircle(
                        color: Color(0xFF2EF7F7),
                      );
                    }
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
