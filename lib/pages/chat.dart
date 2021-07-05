import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'chatdetail.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: StreamBuilder<dynamic>(
              stream: _firestore
                  .collection("Users")
                  .doc(_auth.currentUser!.uid)
                  .collection("Favorites")
                  .orderBy("time", descending: true)
                  .snapshots(),
              builder: (context, snapshot0) {
                return snapshot0.hasData
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
                                            builder: (context) => ChatDetail(
                                              name: snapshot1.data["name"],
                                              userId: snapshot1.data["id"],
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
                                                  Text(
                                                    DateTimeFormat.format(
                                                        snapshot0.data
                                                            .docs[index]["time"]
                                                            .toDate(),
                                                        format: 'H:i'),
                                                    style: TextStyle(
                                                        color: Colors.white60,
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
                    : SpinKitFadingCircle(
                        color: Color(0xFF2EF7F7),
                      );
              },
            ),
            height: 500,
          )
        ],
      ),
    );
  }
}
