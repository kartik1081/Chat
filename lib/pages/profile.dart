// ignore: unused_import
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textme/pages/signin.dart';

import 'editprofile.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  late File _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        title: new Text("Profile"),
        actions: [
          new IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => new SignIn(),
                ),
              );
            },
            icon: new Icon(Icons.logout),
          ),
        ],
      ),
      body: new SafeArea(
        child: new Stack(
          children: [
            new Positioned(
              top: 10.0,
              left: 10.0,
              right: 10.0,
              height: MediaQuery.of(context).size.height * 0.3,
              child: new ClipRRect(
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
                                  onTap: () {
                                    getImage();
                                  },
                                  child: new ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: data["profilePic"].isNotEmpty
                                        ? new CachedNetworkImage(
                                            height: 65,
                                            width: 65,
                                            fit: BoxFit.cover,
                                            imageUrl: data["profilePic"],
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
                                            image:
                                                AssetImage("assets/avatar.png"),
                                            height: 65,
                                            width: 65,
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
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
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
              ),
            )
          ],
        ),
      ),
    );
  }

  Future getImage() async {
    try {
      final pickedFile = await ImagePicker()
          .getImage(source: ImageSource.gallery, imageQuality: 30);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        await _storage
            .ref()
            .child("ProfilePic")
            .child("${_auth.currentUser!.uid}")
            .putFile(_image)
            .then((value) {
          if (value.state == TaskState.running) {}
          if (value.state == TaskState.success) {
            value.ref.getDownloadURL().then((value) async {
              await _firestore
                  .collection("Users")
                  .doc("${_auth.currentUser!.uid}")
                  .update({
                "profilePic": value,
              });
            });
          }
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
