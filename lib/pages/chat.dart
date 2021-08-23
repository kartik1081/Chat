import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:textme/models/services/pageroute.dart';

import 'addstatus.dart';
import 'chatdetail.dart';
import 'statusdetail.dart';

class Chat extends StatefulWidget {
  Chat({
    Key? key,
  }) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> with TickerProviderStateMixin {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  late int item;
  late File _image;
  late String url;
  bool net = false;

  @override
  void initState() {
    super.initState();

    _messaging
        .getToken()
        .then((value) => print("FCM token is:" + value.toString()));
    Connectivity().onConnectivityChanged.listen((event) {
      switch (event) {
        case ConnectivityResult.mobile:
          setState(() {
            net = true;
          });
          print(net);
          break;
        case ConnectivityResult.wifi:
          setState(() {
            net = true;
          });
          print(net);
          break;
        default:
          setState(() {
            net = false;
          });
          print(net);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 100.0,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                        left: 10.0,
                        right: 10.0,
                      ),
                      width: 90.0,
                      height: 80.0,
                      child: StreamBuilder<dynamic>(
                        stream: _firestore
                            .collection("Users")
                            .doc(_auth.currentUser!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StatusDetail(
                                          userID: snapshot.data["id"],
                                          profilePic:
                                              snapshot.data["profilePic"],
                                        ),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0),
                                    child: snapshot
                                            .data["profilePic"].isNotEmpty
                                        ? CachedNetworkImage(
                                            height: 49,
                                            width: 49,
                                            fit: BoxFit.cover,
                                            imageUrl:
                                                snapshot.data["profilePic"],
                                            placeholder: (context, url) {
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
                                            image:
                                                AssetImage("assets/avatar.png"),
                                            height: 49,
                                            width: 49,
                                          ),
                                  ),
                                )
                              : Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 8.0),
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100.0),
                                    color: Color(0xFF31444B),
                                  ),
                                );
                        },
                      ),
                    ),
                    Positioned(
                      top: 55.0,
                      left: 55.0,
                      child: InkWell(
                        onTap: () => getImage(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF2EF7F7),
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: Icon(Icons.add),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 80.0,
                    child: StreamBuilder<dynamic>(
                      stream: _firestore
                          .collection("Users")
                          .doc(_auth.currentUser!.uid)
                          .collection("ChatWith")
                          .snapshots(),
                      builder: (context, snapshot0) {
                        return snapshot0.hasData
                            ? ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot0.data.docs.length,
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> data =
                                      snapshot0.data.docs[index].data();
                                  return StreamBuilder<dynamic>(
                                    stream: _firestore
                                        .collection("Status")
                                        .doc(data["id"])
                                        .collection(data["id"])
                                        .snapshots(),
                                    builder: (context, snapshot1) {
                                      if (snapshot1.hasData) {
                                        if (snapshot1.data.docs.length != 0) {
                                          return Container(
                                            width: 80.0,
                                            padding: const EdgeInsets.only(
                                                top: 10.0,
                                                left: 5.0,
                                                right: 5.0),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        StatusDetail(
                                                      userID: data["id"],
                                                      profilePic:
                                                          data["profilePic"],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                                child: data["profilePic"]
                                                        .isNotEmpty
                                                    ? CachedNetworkImage(
                                                        height: 49,
                                                        width: 49,
                                                        fit: BoxFit.cover,
                                                        imageUrl:
                                                            data["profilePic"],
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
                                          );
                                        } else {
                                          return Container();
                                        }
                                      } else {
                                        return Shimmer.fromColors(
                                          baseColor: Color(0xFF31444B),
                                          highlightColor: Color(0xFF4C6872),
                                          child: Container(
                                            height: 20,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                              color: Color(0xFF31444B),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  );
                                },
                              )
                            : SpinKitFadingCircle(color: Color(0xFF2EF7F7));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.white.withOpacity(0.15),
            thickness: 0.5,
          ),
          Expanded(
            child: Container(
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
                                                          child: Text("cancle"),
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
                                              ScalePageRoute(
                                                  widget: ChatDetail(
                                                    name:
                                                        snapshot1.data["name"],
                                                    userId:
                                                        snapshot1.data["id"],
                                                    group: false,
                                                    profilePic: snapshot1
                                                        .data["profilePic"],
                                                  ),
                                                  out: false),
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
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Hero(
                                                        tag: snapshot1
                                                                .data["id"] +
                                                            snapshot1.data[
                                                                "profilePic"],
                                                        child: ClipRRect(
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
                                                                  color: Colors
                                                                      .white,
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
                                                      Text(
                                                        DateTimeFormat.format(
                                                            snapshot0
                                                                .data
                                                                .docs[index]
                                                                    ["time"]
                                                                .toDate(),
                                                            format: 'H:i'),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white60,
                                                            fontSize: 11.5),
                                                      ),
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
            ),
          ),
        ],
      ),
    );
  }

  Future getImage() async {
    try {
      final pickedFile = await ImagePicker()
          .getImage(source: ImageSource.gallery, imageQuality: 100);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) {
                return AddStatus(
                  image: _image,
                );
              },
              fullscreenDialog: true),
        ).whenComplete(() {
          setState(() {});
        });
      } else if (pickedFile == null) {
        WillPopScope(
          child: Container(),
          onWillPop: () async => true,
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
