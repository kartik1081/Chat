import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_stories/flutter_instagram_stories.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

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

class _ChatState extends State<Chat> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  late int item;
  late File _image;
  bool _loading = false;
  late String url;
  static String collectionDbName = 'Status';
  @override
  Widget build(BuildContext context) {
    CollectionReference dbInstance = _firestore.collection(collectionDbName);
    return Scaffold(
      body: Column(
        children: [
          // FlutterInstagramStories(
          //   collectionDbName: collectionDbName,
          //   showTitleOnIcon: true,
          //   backFromStories: () {
          //     _backFromStoriesAlert();
          //   },
          //   iconTextStyle: TextStyle(
          //     fontSize: 14.0,
          //     color: Colors.white,
          //   ),
          //   iconImageBorderRadius: BorderRadius.circular(15.0),
          //   iconBoxDecoration: BoxDecoration(
          //     borderRadius: BorderRadius.all(Radius.circular(15.0)),
          //     color: Color(0xFFffffff),
          //     boxShadow: [
          //       BoxShadow(
          //         color: Color(0xff333333),
          //         blurRadius: 10.0,
          //         offset: Offset(
          //           0.0,
          //           4.0,
          //         ),
          //       ),
          //     ],
          //   ),
          //   iconWidth: 150.0,
          //   iconHeight: 150.0,
          //   textInIconPadding:
          //       EdgeInsets.only(left: 8.0, right: 8.0, bottom: 12.0),
          //   //how long story lasts in seconds
          //   imageStoryDuration: 7,
          //   progressPosition: ProgressPosition.top,
          //   repeat: true,
          //   inline: false,
          //   languageCode: 'en',
          //   backgroundColorBetweenStories: Colors.black,
          //   closeButtonIcon: Icon(
          //     Icons.close,
          //     color: Colors.white,
          //     size: 28.0,
          //   ),
          //   closeButtonBackgroundColor: Color(0x11000000),
          //   sortingOrderDesc: true,
          //   lastIconHighlight: true,
          //   lastIconHighlightColor: Colors.deepOrange,
          //   lastIconHighlightRadius: const Radius.circular(15.0),
          //   captionTextStyle: TextStyle(
          //     fontSize: 22,
          //     color: Colors.white,
          //   ),
          //   captionMargin: EdgeInsets.only(
          //     bottom: 50,
          //   ),
          //   captionPadding: EdgeInsets.symmetric(
          //     horizontal: 24,
          //     vertical: 8,
          //   ),
          // ),
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
                    .collection("Favorites")
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
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatDetail(
                                                  name: snapshot1.data["name"],
                                                  userId: snapshot1.data["id"],
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
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Hero(
                                                        tag: snapshot1
                                                            .data["id"],
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
                                            color: Color(0xFF3C355A),
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
          _loading = true;
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
          setState(() {
            _loading = false;
          });
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

  _backFromStoriesAlert() {
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        title: Text(
          "User have looked stories and closed them.",
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18.0),
        ),
        children: <Widget>[
          SimpleDialogOption(
            child: Text("Dismiss"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
