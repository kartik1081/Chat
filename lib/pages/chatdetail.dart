import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:textme/pages/chatpage.dart';
import 'package:textme/pages/homepage.dart';
import 'package:textme/pages/usersprofile.dart';

// ignore: must_be_immutable
class ChatDetail extends StatefulWidget {
  ChatDetail(
      {Key? key,
      required this.name,
      required this.userId,
      required this.profilePic})
      : super(key: key);
  late String name, userId, profilePic;

  @override
  _ChatDetailState createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isTapped = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController msg = TextEditingController();
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
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
                  tag: widget.userId,
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
          actions: [
            _isTapped
                ? IconButton(onPressed: () {}, icon: Icon(Icons.star))
                : Text("")
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                alignment: Alignment.bottomCenter,
                child: StreamBuilder<dynamic>(
                  stream: _firestore
                      .collection("Chats")
                      .doc(_auth.currentUser!.uid)
                      .collection(_auth.currentUser!.uid + "_" + widget.userId)
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
                          return Container(
                            alignment: snapshot.data.docs[index]["sendBy"] ==
                                    _auth.currentUser!.uid
                                ? Alignment.bottomRight
                                : Alignment.bottomLeft,
                            margin: const EdgeInsets.only(
                              bottom: 8.0,
                            ),
                            width: MediaQuery.of(context).size.width,
                            color: _isTapped
                                ? Colors.white.withOpacity(0.2)
                                : Color(0xFF2B2641),
                            child: snapshot.data.docs[index]["sendBy"] ==
                                    _auth.currentUser!.uid
                                ? InkWell(
                                    onTap: () {
                                      setState(() {
                                        _isTapped = !_isTapped;
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 7.0),
                                      padding: const EdgeInsets.only(
                                          top: 5.0,
                                          bottom: 5.0,
                                          left: 20.0,
                                          right: 20.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(20.0),
                                          bottomLeft: Radius.circular(20.0),
                                        ),
                                        color: Color(0xFF8ECECE),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            snapshot.data.docs[index]["msg"],
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(
                                            DateTimeFormat.format(
                                                snapshot
                                                    .data.docs[index]["time"]
                                                    .toDate(),
                                                format: 'H:i'),
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      setState(() {
                                        _isTapped = !_isTapped;
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 7.0),
                                      padding: const EdgeInsets.only(
                                          top: 5.0,
                                          bottom: 5.0,
                                          left: 20.0,
                                          right: 20.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(20.0),
                                          bottomRight: Radius.circular(20.0),
                                        ),
                                        color: Colors.white60,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            snapshot.data.docs[index]["msg"],
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(
                                            DateTimeFormat.format(
                                                snapshot
                                                    .data.docs[index]["time"]
                                                    .toDate(),
                                                format: 'H:i'),
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          );
                        },
                      );
                    } else {
                      return SpinKitFadingCircle(color: Color(0xFF2EF7F7));
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
                            return "Type your messege!";
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
                              const EdgeInsets.fromLTRB(13.0, 10.0, 0.0, 10.0),
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
                        try {
                          await _firestore
                              .collection("Chats")
                              .doc(_auth.currentUser!.uid)
                              .collection(
                                  _auth.currentUser!.uid + "_" + widget.userId)
                              .add({
                            "msg": msg.text,
                            "sendBy": _auth.currentUser!.uid,
                            "time": DateTime.now(),
                          }).whenComplete(() async {
                            await _firestore
                                .collection("Chats")
                                .doc(widget.userId)
                                .collection(widget.userId +
                                    "_" +
                                    _auth.currentUser!.uid)
                                .add({
                              "msg": msg.text,
                              "sendBy": _auth.currentUser!.uid,
                              "time": DateTime.now(),
                            });
                          }).whenComplete(() {
                            setState(() {
                              msg.clear();
                            });
                          }).whenComplete(() async {
                            await _firestore
                                .collection("Users")
                                .doc(_auth.currentUser!.uid)
                                .collection("Favorites")
                                .doc(widget.userId)
                                .set({
                              "name": widget.name,
                              "profilePic": widget.profilePic,
                              "time": DateTime.now(),
                              "id": widget.userId,
                            });
                          });
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
}
