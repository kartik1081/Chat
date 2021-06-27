import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:textme/pages/chatdetail.dart';

// ignore: must_be_immutable
class ChatList extends StatefulWidget {
  ChatList({Key? key}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new StreamBuilder<dynamic>(
        stream: _firestore
            .collection("Users")
            .doc(_auth.currentUser!.uid)
            .collection("Favorites")
            .orderBy("time", descending: true)
            .snapshots(),
        builder: (context, snapshot0) {
          return snapshot0.hasData
              ? new ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot0.data.docs.length,
                  itemBuilder: (context, index) {
                    return new StreamBuilder<dynamic>(
                      stream: _firestore
                          .collection("Users")
                          .doc(snapshot0.data.docs[index]["id"])
                          .snapshots(),
                      builder: (context, snapshot1) {
                        return snapshot1.hasData
                            ? new InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => new ChatDetail(
                                        name: snapshot1.data["name"],
                                        userId: snapshot1.data["id"],
                                        profilePic:
                                            snapshot1.data["profilePic"],
                                      ),
                                    ),
                                  );
                                },
                                child: new Container(
                                  height: snapshot1.data["id"] !=
                                          _auth.currentUser!.uid
                                      ? 80.0
                                      : 0.0,
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0, top: 10.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        new Row(
                                          children: [
                                            new Hero(
                                              tag: snapshot1.data["id"],
                                              child: new ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: snapshot1
                                                        .data["profilePic"]
                                                        .isNotEmpty
                                                    ? new CachedNetworkImage(
                                                        height: 49,
                                                        width: 49,
                                                        fit: BoxFit.cover,
                                                        imageUrl: snapshot1
                                                            .data["profilePic"],
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
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  new Text(
                                                    snapshot1.data["name"],
                                                    style: new TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                  new SizedBox(
                                                    height: 3.0,
                                                  ),
                                                  new Text(
                                                    "Last Message",
                                                    style: new TextStyle(
                                                        color: Colors.white60,
                                                        fontSize: 11.5),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            new Text(
                                              DateTimeFormat.format(
                                                  snapshot0
                                                      .data.docs[index]["time"]
                                                      .toDate(),
                                                  format: 'H:i'),
                                              style: new TextStyle(
                                                  color: Colors.white60,
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
                            : new Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 8.0),
                                height: 60,
                                color: Color(0xFF3C355A),
                              );
                      },
                    );
                  },
                )
              : new SpinKitFadingCircle(color: Color(0xFF2EF7F7));
        },
      ),
      height: 500,
    );
  }
}
