import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:textme/pages/chatdetail.dart';

// ignore: must_be_immutable
class ChatList extends StatelessWidget {
  ChatList({Key? key}) : super(key: key);

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
              .orderBy("time", descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? new ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return new OpenContainer(
                        closedColor: Color(0xFF2B2641),
                        openBuilder: (context, action) {
                          return ChatDetail(
                            name: snapshot.data.docs[index]["name"],
                            userId: snapshot.data.docs[index]["id"],
                            profilePic: snapshot.data.docs[index]["profilePic"],
                          );
                        },
                        closedBuilder: (context, action) {
                          return Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: new ListTile(
                              leading: new ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: snapshot.data.docs[index]["profilePic"]
                                        .isNotEmpty
                                    ? new CachedNetworkImage(
                                        height: 55,
                                        width: 55,
                                        fit: BoxFit.cover,
                                        imageUrl: snapshot.data.docs[index]
                                            ["profilePic"],
                                        placeholder: (context, url) {
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
                                        image: AssetImage("assets/avatar.png"),
                                        height: 55,
                                        width: 55,
                                      ),
                              ),
                              title: new Text(
                                snapshot.data.docs[index]["name"],
                                style: new TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800),
                              ),
                              subtitle: new Text(
                                "Subtitle",
                                style: new TextStyle(
                                    color: Colors.white60, fontSize: 12),
                              ),
                              trailing: new Text(
                                "Time",
                                style: new TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                : new SpinKitFadingCircle(
                    color: Color(0xFF2EF7F7),
                    size: 50,
                  );
          }),
      height: 500,
    );
  }
}
