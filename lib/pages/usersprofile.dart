import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:textme/pages/homepage.dart';

// ignore: must_be_immutable
class UsersProfile extends StatefulWidget {
  UsersProfile(
      {Key? key,
      required this.name,
      required this.profilePic,
      required this.userId})
      : super(key: key);
  late String name, userId, profilePic;

  @override
  _UsersProfileState createState() => _UsersProfileState();
}

class _UsersProfileState extends State<UsersProfile> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: CachedNetworkImage(
              imageUrl: widget.profilePic,
              fit: BoxFit.fitWidth,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          StreamBuilder<dynamic>(
              stream: _firestore
                  .collection("Users")
                  .doc(_auth.currentUser!.uid)
                  .collection("ChatWith")
                  .where("id", isEqualTo: widget.userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data["id"]
                      ? InkWell(
                          onTap: () async {
                            await _firestore
                                .collection("Users")
                                .doc(_auth.currentUser!.uid)
                                .collection("ChatWith")
                                .doc(widget.userId)
                                .delete();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ),
                            );
                          },
                          child: Container(
                            alignment: Alignment.bottomRight,
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                              ),
                              height: 40,
                              width: 100,
                              child: Center(child: Text("Remove")),
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () async {
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ),
                            );
                          },
                          child: Container(
                            alignment: Alignment.bottomRight,
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                              ),
                              height: 40,
                              width: 100,
                              child: Center(child: Text("Add")),
                            ),
                          ),
                        );
                } else {
                  return Container();
                }
              })
        ],
      ),
    );
  }
}
