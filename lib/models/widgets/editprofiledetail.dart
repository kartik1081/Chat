import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:textme/pages/editprofile.dart';

// ignore: must_be_immutable
class EditProfileDetail extends StatelessWidget {
  EditProfileDetail({Key? key}) : super(key: key);
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return new ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(40.0)),
      child: new Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width,
        height: 250,
        color: Colors.white.withOpacity(0.7),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            new StreamBuilder<dynamic>(
              stream: _firestore
                  .collection("Users")
                  .doc("${_auth.currentUser!.uid}")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map<String, dynamic> data = snapshot.data.data();
                  return new Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      new InkWell(
                        onTap: () {},
                        child: new ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: data["profilePic"] == null
                              ? new Image(
                                  image: AssetImage("assets/avatar.png"),
                                  height: 75,
                                  width: 75,
                                )
                              : new CachedNetworkImage(
                                  height: 75,
                                  width: 75,
                                  fit: BoxFit.cover,
                                  imageUrl: data["profilePic"],
                                  placeholder: (context, url) {
                                    return new Container(
                                      height: 100,
                                      child: new Center(
                                        child: new CircularProgressIndicator(),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                      new SizedBox(
                        width: 10,
                      ),
                      new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          new Text(
                            data["name"],
                            style: new TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w800),
                          ),
                          new Text(
                            data["email"],
                            style: new TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                }
                return new CircularProgressIndicator();
              },
            ),
            new SizedBox(
              height: 10,
            ),
            new Container(
              width: 300,
              decoration: new BoxDecoration(),
              child: new ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new EditProfile(),
                        fullscreenDialog: true),
                  );
                },
                child: new Text(
                  "Edit Profile",
                  style: new TextStyle(color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
