import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  late FToast fToast;
  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
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
            // height: 200,
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
                  .collection("Favorites")
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
                                .collection("Favorites")
                                .doc(widget.userId)
                                .delete();
                            _showToast("Removed");
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
                                .collection("Favorites")
                                .doc(widget.userId)
                                .set({
                              "name": widget.name,
                              "profilePic": widget.profilePic,
                              "time": DateTime.now(),
                              "id": widget.userId,
                            });
                            _showToast("Removed");
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

  _showToast(String msg) {
    Widget toast = Container(
      width: 110.0,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.grey.withOpacity(0.5),
      ),
      child: Center(
        child: Text(
          msg,
        ),
      ),
    );

    fToast.showToast(
        child: toast,
        toastDuration: Duration(seconds: 2),
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: child,
            top: MediaQuery.of(context).size.height * 0.8,
            left: (MediaQuery.of(context).size.width - 100.0) * 0.5,
          );
        });
  }
}
