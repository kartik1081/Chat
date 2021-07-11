import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textme/pages/statusdetail.dart';

import 'addstatus.dart';

// ignore: must_be_immutable
class Status extends StatefulWidget {
  Status({Key? key}) : super(key: key);

  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  late File _image;
  late String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Stack(
          children: [
            Container(
              height: 90.0,
              padding: const EdgeInsets.symmetric(vertical: 12.5),
              child: StreamBuilder<dynamic>(
                stream: _firestore
                    .collection("Users")
                    .doc("${_auth.currentUser!.uid}")
                    .snapshots(),
                builder: (context, snapshot) {
                  Map<String, dynamic> data = snapshot.data.data();
                  return snapshot.hasData
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StatusDetail(),
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 15.0,
                              ),
                              child: Row(
                                children: [
                                  Hero(
                                    tag: snapshot.data["id"],
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: snapshot
                                              .data["profilePic"].isNotEmpty
                                          ? CachedNetworkImage(
                                              height: 69,
                                              width: 69,
                                              fit: BoxFit.cover,
                                              imageUrl:
                                                  snapshot.data["profilePic"],
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
                                              height: 69,
                                              width: 69,
                                            ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Add Status",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color(0xFF3C355A),
                          ),
                        );
                },
              ),
            ),
            Positioned(
              top: 53.0,
              left: 60.0,
              child: InkWell(
                  onTap: () => getImage(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF2EF7F7),
                      borderRadius: BorderRadius.circular(100.0),
                      border: Border.all(color: Color(0xFF2B2641), width: 2.5),
                    ),
                    child: Icon(Icons.add),
                  )),
            ),
          ],
        ),
        Divider(
          color: Colors.white.withOpacity(0.2),
          thickness: 1.0,
        ),
        Expanded(
          child: Container(
            child: StreamBuilder<dynamic>(
              stream: _firestore
                  .collection("Users")
                  .doc(_auth.currentUser!.uid)
                  .collection("Favorites")
                  .orderBy("time", descending: true)
                  .snapshots(),
              builder: (context, snapshot0) {
                return snapshot0.hasData
                    ? ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot0.data.docs.length,
                        itemBuilder: (context, index) {
                          return StreamBuilder<dynamic>(
                            stream: _firestore
                                .collection("Users")
                                .doc(snapshot0.data.docs[index]["id"])
                                .snapshots(),
                            builder: (context, snapshot1) {
                              return snapshot1.hasData
                                  ? InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                StatusDetail(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: snapshot1.data["id"] !=
                                                _auth.currentUser!.uid
                                            ? 80.0
                                            : 0.0,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0,
                                              right: 15.0,
                                              top: 10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Row(
                                                children: [
                                                  Hero(
                                                    tag: snapshot1.data["id"],
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      child: snapshot1
                                                              .data[
                                                                  "profilePic"]
                                                              .isNotEmpty
                                                          ? CachedNetworkImage(
                                                              height: 49,
                                                              width: 49,
                                                              fit: BoxFit.cover,
                                                              imageUrl: snapshot1
                                                                      .data[
                                                                  "profilePic"],
                                                              placeholder:
                                                                  (context,
                                                                      url) {
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
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          snapshot1
                                                              .data["name"],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800),
                                                        ),
                                                        SizedBox(
                                                          height: 3.0,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    DateTimeFormat.format(
                                                        snapshot0.data
                                                            .docs[index]["time"]
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
                                    )
                                  : Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 8.0),
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Color(0xFF3C355A),
                                      ),
                                    );
                            },
                          );
                        },
                      )
                    : SpinKitFadingCircle(color: Color(0xFF2EF7F7));
              },
            ),
            height: 500,
          ),
        ),
      ],
    ));
  }

  Future getImage() async {
    try {
      final pickedFile = await ImagePicker()
          .getImage(source: ImageSource.gallery, imageQuality: 100);
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
            setState(() async {
              url = await value.ref.getDownloadURL();
            });
          }
        }).whenComplete(
          () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) {
                  return AddStatus(
                    image: _image,
                    url: url,
                  );
                },
                fullscreenDialog: true),
          ),
        );
      } else if (pickedFile == null) {
        WillPopScope(
          child: Container(),
          onWillPop: () async => true,
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
