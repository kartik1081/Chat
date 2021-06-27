import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:textme/pages/chat.dart';

// ignore: must_be_immutable
class UsersProfile extends StatelessWidget {
  UsersProfile(
      {Key? key,
      required this.name,
      required this.profilePic,
      required this.userId})
      : super(key: key);
  late String name, userId, profilePic;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(name),
      ),
      body: new Column(
        children: [
          new Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: new CachedNetworkImage(
              imageUrl: profilePic,
              fit: BoxFit.cover,
            ),
          ),
          new SizedBox(
            height: 10.0,
          ),
          new InkWell(
            onTap: () {
              _firestore
                  .collection("Users")
                  .doc(_auth.currentUser!.uid)
                  .collection("Favorites")
                  .doc(userId)
                  .delete();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => new Chat(),
                ),
              );
            },
            child: new Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                height: 40,
                width: 100,
                child: Center(child: new Text("Remove")),
              ),
            ),
          )
        ],
      ),
    );
  }
}
