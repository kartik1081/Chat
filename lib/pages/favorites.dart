import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:textme/pages/addfavirite.dart';

import 'chat.dart';
import 'chatdetail.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  late FToast fToast;
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    FirebaseAuth _auth = FirebaseAuth.instance;
    Chat _chat = Chat();
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Favorites"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddFavorite()));
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: Container(
          child: StreamBuilder<dynamic>(
            stream: _firestore
                .collection("Users")
                .doc(_auth.currentUser!.uid)
                .collection("ChatWith")
                .where("favorite", isEqualTo: true)
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
                                            builder: (context) => AlertDialog(
                                                  title: Text("Alert"),
                                                  content: Text(
                                                      "Want to remove from chatlist?"),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: Text("cancle"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        _firestore
                                                            .collection("Users")
                                                            .doc(_auth
                                                                .currentUser!
                                                                .uid)
                                                            .collection(
                                                                "ChatWith")
                                                            .doc(snapshot1
                                                                .data["id"])
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
                                            builder: (context) => ChatDetail(
                                              name: snapshot1.data["name"],
                                              userId: snapshot1.data["id"],
                                              group: false,
                                              profilePic:
                                                  snapshot1.data["profilePic"],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: snapshot1.data["id"] !=
                                                _auth.currentUser!.uid
                                            ? 80.0
                                            : 0.0,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0,
                                              right: 15.0,
                                              top: 10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Row(
                                                children: [
                                                  Hero(
                                                    tag: snapshot1.data["id"],
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      child: snapshot1
                                                              .data[
                                                                  "profilePic"]
                                                              .isNotEmpty
                                                          ? CachedNetworkImage(
                                                              height: 49,
                                                              width: 49,
                                                              fit: BoxFit.cover,
                                                              imageUrl: snapshot1
                                                                      .data[
                                                                  "profilePic"],
                                                              placeholder:
                                                                  (context,
                                                                      url) {
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
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          snapshot1
                                                              .data["name"],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800),
                                                        ),
                                                        SizedBox(
                                                          height: 3.0,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        _firestore
                                                            .collection("Users")
                                                            .doc(_auth
                                                                .currentUser!
                                                                .uid)
                                                            .collection(
                                                                "ChatWith")
                                                            .doc(snapshot1
                                                                .data["id"])
                                                            .update({
                                                          "favorite": false
                                                        }).whenComplete(() {
                                                          _showToast("Removed");
                                                        });
                                                      },
                                                      icon: Icon(Icons.delete,
                                                          color:
                                                              Colors.redAccent))
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
                          "Add user to favorite list",
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
        ),
      ),
    );
  }

  _showToast(String msg) {
    Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.white,
        ),
        child: Text(msg));

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 3),
    );
  }
}
