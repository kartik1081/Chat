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
  bool edit = false;
  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: Container(
        child: StreamBuilder<dynamic>(
          stream: _firestore
              .collection("Users")
              .doc("${_auth.currentUser!.uid}")
              .snapshots(),
          builder: (context, snapshot) {
            Map<String, dynamic> data = snapshot.data.data();
            return snapshot.hasData
                ? Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 30.0),
                        child: Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: data["profilePic"].isNotEmpty
                                      ? CachedNetworkImage(
                                          height: 120,
                                          width: 120,
                                          fit: BoxFit.cover,
                                          imageUrl: data["profilePic"],
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
                                          image:
                                              AssetImage("assets/avatar.png"),
                                          height: 120,
                                          width: 120,
                                        ),
                                ),
                                SizedBox(
                                  height: 40.0,
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.person,
                                            color: Colors.white70,
                                          ),
                                          SizedBox(
                                            width: 15.0,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Name",
                                                style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 15.0),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Text(
                                                data["name"],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Text(
                                                "This is not your username or pin. This name \n will be visible to your TextMe users.",
                                                style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 15.0),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.help_center,
                                          color: Colors.white70,
                                        ),
                                        SizedBox(
                                          width: 15.0,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              "About",
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 15.0),
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              "About",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.email,
                                          color: Colors.white70,
                                        ),
                                        SizedBox(
                                          width: 15.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Email",
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 15.0),
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              data["email"],
                                              style: TextStyle(
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
                      Positioned(
                        top: 115.0,
                        left: 215.0,
                        child: InkWell(
                          onTap: () {
                            getImage();
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              height: 40.0,
                              width: 40.0,
                              color: Color(0xFF2EF7F7),
                              child: Icon(Icons.add),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : SpinKitFadingCircle(color: Color(0xFF2EF7F7));
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
