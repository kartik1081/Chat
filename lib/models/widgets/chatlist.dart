import 'package:animations/animations.dart';
import 'package:date_format/date_format.dart';
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
                          .where("id",
                              isEqualTo: snapshot.data.docs[index]["id"])
                          .snapshots(),
                      builder: (context, snapshots) {
                        Map<String, dynamic> data = snapshots.data.data();
                        return snapshots.hasData
                            ? new InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => new ChatDetail(
                                        name: data["name"],
                                        userId: data["id"],
                                        profilePic: data["profilePic"],
                                      ),
                                    ),
                                  );
                                },
                                child: new Container(
                                  height: data["id"] != _auth.currentUser!.uid
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
                                                child: data["profilePic"]
                                                        .isNotEmpty
                                                    ? new CachedNetworkImage(
                                                        height: 49,
                                                        width: 49,
                                                        fit: BoxFit.cover,
                                                        imageUrl:
                                                            data["profilePic"],
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
                                                    data["name"],
                                                    style: new TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                  new SizedBox(
                                                    height: 3.0,
                                                  ),
                                                  new Text(
                                                    "Last Messege",
                                                    style: new TextStyle(
                                                        color: Colors.white60,
                                                        fontSize: 11.5),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            new Text(
                                              DateTimeFormat.format(
                                                  snapshot
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
                            : new SpinKitFadingCircle(color: Color(0xFF2EF7F7));
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
