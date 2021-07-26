import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:textme/pages/createroom.dart';
import 'package:uuid/uuid.dart';

import 'chatdetail.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  late var uuid;

  @override
  void initState() {
    super.initState();
    setState(() {
      uuid = Uuid().v4();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder<dynamic>(
          stream: _firestore
              .collection("Users")
              .doc(_auth.currentUser!.uid)
              .collection("InRoom")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data.docs.length != 0
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
                                builder: (context) => ChatDetail(
                                  name: snapshot.data.docs[index]["roomName"],
                                  userId: uuid,
                                  group: true,
                                  profilePic: snapshot.data.docs[index]
                                      ["roomPic"],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 80.0,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0, top: 10.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Row(
                                    children: [
                                      Hero(
                                        tag: snapshot.data.docs[index]["id"],
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: snapshot
                                                  .data
                                                  .docs[index]["roomPic"]
                                                  .isNotEmpty
                                              ? CachedNetworkImage(
                                                  height: 49,
                                                  width: 49,
                                                  fit: BoxFit.cover,
                                                  imageUrl: snapshot.data
                                                      .docs[index]["roomPic"],
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
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data.docs[index]
                                                  ["roomName"],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            SizedBox(
                                              height: 3.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        DateTimeFormat.format(
                                            snapshot.data.docs[index]["time"]
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
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        "Create room",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                    );
            } else {
              return SpinKitFadingCircle(
                color: Color(0xFF2EF7F7),
                size: 50,
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateRoom(
                      uuid: uuid.toString(),
                    ),
                fullscreenDialog: true),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
