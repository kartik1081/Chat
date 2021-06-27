import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  late File _image;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Edit Profile"),
      ),
      body: new Container(
        child: new StreamBuilder<dynamic>(
          stream: _firestore
              .collection("Users")
              .doc("${_auth.currentUser!.uid}")
              .snapshots(),
          builder: (context, snapshot) {
            Map<String, dynamic> data = snapshot.data.data();
            return snapshot.hasData
                ? new Stack(
                    children: [
                      new Container(
                        margin: const EdgeInsets.only(top: 30.0),
                        child: new Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                new ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: data["profilePic"].isNotEmpty
                                      ? new CachedNetworkImage(
                                          height: 120,
                                          width: 120,
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
                                          height: 120,
                                          width: 120,
                                        ),
                                ),
                                new SizedBox(
                                  height: 40.0,
                                ),
                                new Column(
                                  children: [
                                    new Row(
                                      children: [
                                        new Icon(
                                          Icons.person,
                                          color: Colors.white70,
                                        ),
                                        new SizedBox(
                                          width: 15.0,
                                        ),
                                        new Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            new Row(
                                              children: [
                                                new Column(
                                                  children: [
                                                    new Text(
                                                      "Name",
                                                      style: new TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 15.0),
                                                    ),
                                                    new SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    new Text(
                                                      data["name"],
                                                      style: new TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                new SizedBox(
                                                  width: 245.0,
                                                ),
                                                new IconButton(
                                                  onPressed: () {},
                                                  icon: new Icon(
                                                    Icons.edit,
                                                    color: Color(0xFF2EF7F7),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            new SizedBox(
                                              height: 5.0,
                                            ),
                                            new Text(
                                              "This is not your username or pin. This name will \n be visible to your TextMe contacts.",
                                              style: new TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 15.0),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    new SizedBox(
                                      height: 15.0,
                                    ),
                                    new Row(
                                      children: [
                                        new Icon(
                                          Icons.help_center,
                                          color: Colors.white70,
                                        ),
                                        new SizedBox(
                                          width: 15.0,
                                        ),
                                        new Column(
                                          children: [
                                            new Text(
                                              "About",
                                              style: new TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 15.0),
                                            ),
                                            new SizedBox(
                                              height: 5.0,
                                            ),
                                            new Text(
                                              "About",
                                              style: new TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        new SizedBox(
                                          width: 240.0,
                                        ),
                                        new IconButton(
                                            onPressed: () {},
                                            icon: new Icon(
                                              Icons.edit,
                                              color: Color(0xFF2EF7F7),
                                            ))
                                      ],
                                    ),
                                    new SizedBox(
                                      height: 15.0,
                                    ),
                                    new Row(
                                      children: [
                                        new Icon(
                                          Icons.email,
                                          color: Colors.white70,
                                        ),
                                        new SizedBox(
                                          width: 15.0,
                                        ),
                                        new Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            new Text(
                                              "Email",
                                              style: new TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 15.0),
                                            ),
                                            new SizedBox(
                                              height: 5.0,
                                            ),
                                            new Text(
                                              data["email"],
                                              style: new TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      new Positioned(
                        top: 115.0,
                        left: 215.0,
                        child: new InkWell(
                          onTap: () {
                            getImage();
                          },
                          child: new ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: new Container(
                              height: 40.0,
                              width: 40.0,
                              color: Color(0xFF2EF7F7),
                              child: new Icon(Icons.add),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : new SpinKitFadingCircle(color: Color(0xFF2EF7F7));
          },
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
