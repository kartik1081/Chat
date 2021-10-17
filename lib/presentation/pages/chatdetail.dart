import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:textme/models/services/pageroute.dart';
import 'package:uuid/uuid.dart';
import 'package:bubble/bubble.dart';
import 'homepage.dart';
import 'usersprofile.dart';

// ignore: must_be_immutable
class ChatDetail extends StatefulWidget {
  ChatDetail(
      {Key? key,
      required this.name,
      required this.userId,
      required this.group,
      required this.profilePic})
      : super(key: key);
  late String name, userId, profilePic;
  bool group;

  @override
  _ChatDetailState createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  late var uuid;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController msg = TextEditingController();
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.push(context,
                    SlidePageRoute(widget: HomePage(), direction: "left"));
              },
              icon: Icon(Icons.keyboard_arrow_left)),
          titleSpacing: 0,
          title: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UsersProfile(
                              name: widget.name,
                              userId: widget.userId,
                              profilePic: widget.profilePic,
                            ),
                        fullscreenDialog: true),
                  );
                },
                child: Hero(
                  tag: widget.userId + widget.profilePic,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    // ignore: unnecessary_null_comparison
                    child: widget.profilePic.isNotEmpty
                        ? CachedNetworkImage(
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                            imageUrl: widget.profilePic,
                            placeholder: (context, url) {
                              return Container(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                          )
                        : Image(
                            image: AssetImage("assets/avatar.png"),
                            height: 40,
                            width: 40,
                          ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "${widget.name}",
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
          // actions: [
          //   !widget.group
          //       ? StreamBuilder<dynamic>(
          //           stream: _firestore
          //               .collection("Users")
          //               .doc(_auth.currentUser!.uid)
          //               .collection("ChatWith")
          //               .doc(widget.userId)
          //               .snapshots(),
          //           builder: (context, snapshot) {
          //             return snapshot.hasData
          //                 ? IconButton(
          //                     onPressed: () {
          //                       _firestore
          //                           .collection("Users")
          //                           .doc(_auth.currentUser!.uid)
          //                           .collection("ChatWith")
          //                           .doc(widget.userId)
          //                           .update({
          //                         "favorite":
          //                             snapshot.data["favorite"] ? false : true
          //                       });
          //                     },
          //                     icon: Icon(
          //                       Icons.favorite,
          //                       color: snapshot.data["favorite"]
          //                           ? Colors.red
          //                           : Colors.grey,
          //                     ))
          //                 : Container();
          //           })
          //       : Container()
          // ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                alignment: Alignment.bottomCenter,
                child: widget.group
                    ? StreamBuilder<dynamic>(
                        stream: _firestore
                            .collection("Chats")
                            .doc("RoomChats")
                            .collection(widget.userId)
                            .where("msg")
                            .orderBy("time", descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              reverse: true,
                              shrinkWrap: true,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                return snapshot.data.docs[index]["deleted"]
                                    ? Container()
                                    : Container(
                                        alignment: snapshot.data.docs[index]
                                                    ["sendBy"] ==
                                                _auth.currentUser!.uid
                                            ? Alignment.bottomRight
                                            : Alignment.bottomLeft,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Color(0xFF07232c),
                                        child: snapshot.data.docs[index]
                                                    ["sendBy"] ==
                                                _auth.currentUser!.uid
                                            ? msgContainer(
                                                Color(0xFF8ECECE),
                                                snapshot.data.docs[index]
                                                    ["msg"],
                                                snapshot.data.docs[index]
                                                    ["time"],
                                                snapshot.data.docs[index]
                                                    ["sendBy"],
                                                snapshot.data.docs[index]
                                                    ["msgID"],
                                                snapshot.data.docs[index]
                                                    ["stared"],
                                                true,
                                                true)
                                            : msgContainer(
                                                Colors.white60,
                                                snapshot.data.docs[index]
                                                    ["msg"],
                                                snapshot.data.docs[index]
                                                    ["time"],
                                                snapshot.data.docs[index]
                                                    ["sendBy"],
                                                snapshot.data.docs[index]
                                                    ["msgID"],
                                                snapshot.data.docs[index]
                                                    ["stared"],
                                                false,
                                                true),
                                      );
                              },
                            );
                          } else {
                            return SpinKitFadingCircle(
                                color: Color(0xFF2EF7F7));
                          }
                        },
                      )
                    : StreamBuilder<dynamic>(
                        stream: _firestore
                            .collection("Chats")
                            .doc(_auth.currentUser!.uid)
                            .collection(
                                _auth.currentUser!.uid + "_" + widget.userId)
                            .where("msg")
                            .orderBy("time", descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Expanded(
                              flex: 1,
                              child: ListView.builder(
                                reverse: true,
                                shrinkWrap: true,
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  return snapshot.data.docs[index]["deleted"]
                                      ? Container()
                                      : Container(
                                          alignment: snapshot.data.docs[index]
                                                      ["sendBy"] ==
                                                  _auth.currentUser!.uid
                                              ? Alignment.bottomRight
                                              : Alignment.bottomLeft,
                                          margin: const EdgeInsets.only(
                                            bottom: 8.0,
                                          ),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          color: Color(0xFF07232c),
                                          child: snapshot.data.docs[index]
                                                      ["sendBy"] ==
                                                  _auth.currentUser!.uid
                                              ? msgContainer(
                                                  Color(0xFF8ECECE),
                                                  snapshot.data.docs[index]
                                                      ["msg"],
                                                  snapshot.data.docs[index]
                                                      ["time"],
                                                  snapshot.data.docs[index]
                                                      ["sendBy"],
                                                  snapshot.data.docs[index]
                                                      ["msgID"],
                                                  snapshot.data.docs[index]
                                                      ["stared"],
                                                  true,
                                                  false)
                                              : msgContainer(
                                                  Colors.white60,
                                                  snapshot.data.docs[index]
                                                      ["msg"],
                                                  snapshot.data.docs[index]
                                                      ["time"],
                                                  snapshot.data.docs[index]
                                                      ["sendBy"],
                                                  snapshot.data.docs[index]
                                                      ["msgID"],
                                                  snapshot.data.docs[index]
                                                      ["stared"],
                                                  false,
                                                  false),
                                        );
                                },
                              ),
                            );
                          } else {
                            return SpinKitFadingCircle(
                                color: Color(0xFF2EF7F7));
                          }
                        },
                      ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 4.0, bottom: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(35),
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter message";
                          }
                        },
                        controller: msg,
                        cursorHeight: 22.0,
                        decoration: InputDecoration(
                          // isDense: true,
                          hintText: "Type your messege",
                          hintStyle: TextStyle(color: Colors.grey),
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding:
                              const EdgeInsets.fromLTRB(13.0, 10.0, 13.0, 10.0),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 0.0000000001, color: Colors.black),
                              borderRadius: BorderRadius.circular(10.0)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 0.0000000001, color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        uuid = Uuid().v4();
                        try {
                          if (msg.text.isNotEmpty) {
                            widget.group
                                ? _firestore
                                    .collection("Chats")
                                    .doc("RoomChats")
                                    .collection(widget.userId)
                                    .doc(uuid.toString())
                                    .set({
                                    "msg": msg.text,
                                    "msgID": uuid.toString(),
                                    "time": DateTime.now(),
                                    "sendBy": _auth.currentUser!.uid,
                                    "stared": false,
                                    "deleted": false,
                                  }).whenComplete(() {
                                    _firestore.collection("Notifications").add({
                                      "msg": msg.text,
                                      "room": widget.userId
                                    });
                                  }).whenComplete(() {
                                    setState(() {
                                      msg.clear();
                                    });
                                  })
                                : await _firestore
                                    .collection("Chats")
                                    .doc(_auth.currentUser!.uid)
                                    .collection(_auth.currentUser!.uid +
                                        "_" +
                                        widget.userId)
                                    .doc(uuid.toString())
                                    .set({
                                      "msg": msg.text,
                                      "msgID": uuid.toString(),
                                      "stared": false,
                                      "deleted": false,
                                      "sendBy": _auth.currentUser!.uid,
                                      "time": DateTime.now(),
                                    })
                                    .whenComplete(() async {
                                      await _firestore
                                          .collection("Chats")
                                          .doc(widget.userId)
                                          .collection(widget.userId +
                                              "_" +
                                              _auth.currentUser!.uid)
                                          .doc(uuid.toString())
                                          .set({
                                        "msg": msg.text,
                                        "msgID": uuid.toString(),
                                        "stared": false,
                                        "deleted": false,
                                        "sendBy": _auth.currentUser!.uid,
                                        "time": DateTime.now(),
                                      });
                                    })
                                    .whenComplete(() => _firestore
                                            .collection("Notifications")
                                            .add({
                                          "msg": msg.text,
                                          "sendBy": _auth.currentUser!.uid,
                                          "sendTo": widget.userId
                                        }))
                                    .whenComplete(() {
                                      setState(() {
                                        msg.clear();
                                      });
                                    })
                                    .whenComplete(() async {
                                      await _firestore
                                          .collection("Users")
                                          .doc(_auth.currentUser!.uid)
                                          .collection("ChatWith")
                                          .doc(widget.userId)
                                          .set({
                                        "name": widget.name,
                                        "profilePic": widget.profilePic,
                                        "time": DateTime.now(),
                                        "id": widget.userId,
                                      });
                                    });
                          }
                        } catch (e) {
                          print(e.toString());
                        }
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Icon(Icons.send),
                        ),
                        color: Colors.white,
                        height: 50,
                        width: 50,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget msgContainer(Color c, String msg, Timestamp time, String sendBy,
      String msgID, bool stared, bool right, bool group) {
    return InkWell(
      onDoubleTap: () {
        starDialog(msgID, msg, group, stared);
      },
      onLongPress: () {
        removeDialog(msgID, msg, group);
      },
      child: Container(
        child: Bubble(
          margin: BubbleEdges.only(top: 10),
          alignment: right ? Alignment.topRight : null,
          nipWidth: 9,
          nipHeight: 8,
          nip: right ? BubbleNip.rightBottom : BubbleNip.leftBottom,
          color: c,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 200.0),
                child: Container(
                  child: group
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StreamBuilder<dynamic>(
                                stream: _firestore
                                    .collection("Users")
                                    .doc(sendBy)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  return Text(
                                    snapshot.hasData
                                        ? snapshot.data["name"]
                                        : "Name",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w800),
                                  );
                                }),
                            Text(
                              msg,
                              style: TextStyle(fontWeight: FontWeight.w600),
                              maxLines: 100,
                            ),
                          ],
                        )
                      : Text(
                          msg,
                          style: TextStyle(fontWeight: FontWeight.w600),
                          maxLines: 100,
                        ),
                ),
              ),
              SizedBox(
                width: 13.0,
              ),
              Row(
                children: [
                  Text(
                    DateTimeFormat.format(time.toDate(), format: 'H:i'),
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.8), fontSize: 10.5),
                  ),
                  stared
                      ? Icon(
                          Icons.star,
                          color: Color(0xFF07232c).withOpacity(0.8),
                          size: 15.0,
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  removeDialog(String msgID, String msg, bool group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Remove message"),
        content: Text("\" " + msg + " \""),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("cancle"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              group
                  ? _firestore
                      .collection("Chats")
                      .doc("RoomChats")
                      .collection(widget.userId)
                      .doc(msgID)
                      .update({"deleted": true})
                  : _firestore
                      .collection("Chats")
                      .doc(_auth.currentUser!.uid)
                      .collection(_auth.currentUser!.uid + "_" + widget.userId)
                      .doc(msgID)
                      .update({"deleted": true});
            },
            child: Text("delete"),
          ),
        ],
      ),
    );
  }

  starDialog(String msgID, String msg, bool group, bool stared) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: stared ? Text("Unstar message") : Text("Star message"),
        content: Text("\" " + msg + " \""),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("cancle"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              group
                  ? _firestore
                      .collection("Chats")
                      .doc("RoomChats")
                      .collection(widget.userId)
                      .doc(msgID)
                      .update(stared ? {"stared": false} : {"stared": true})
                  : _firestore
                      .collection("Chats")
                      .doc(_auth.currentUser!.uid)
                      .collection(_auth.currentUser!.uid + "_" + widget.userId)
                      .doc(msgID)
                      .update(stared ? {"stared": false} : {"stared": true});
            },
            child: stared ? Text("Unstar") : Text("Star"),
          ),
        ],
      ),
    );
  }
}
