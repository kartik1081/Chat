import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'chatdetail.dart';

class CreateRoom extends StatefulWidget {
  CreateRoom({Key? key, required this.uuid}) : super(key: key);
  String uuid;

  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  TextEditingController _name = TextEditingController();
  bool named = false;
  bool imaged = false;
  bool picked = false;
  late String roomName;
  String roomPic = '';
  late File _image;
  // late String profilePic;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();

    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: named
            ? imaged
                ? Row(
                    children: [
                      InkWell(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => UsersProfile(
                          //             name: widget.name,
                          //             userId: widget.userId,
                          //             profilePic: widget.profilePic,
                          //           ),
                          //       fullscreenDialog: true),
                          // );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          // ignore: unnecessary_null_comparison
                          child: roomPic == ''
                              ? Image(
                                  image: NetworkImage(
                                      "https://firebasestorage.googleapis.com/v0/b/textme-32c91.appspot.com/o/Status%2Favatar.png?alt=media&token=82fbbc78-7e2f-4f0a-9b38-d689e080913f"),
                                  height: 40,
                                  width: 40,
                                )
                              : Image(
                                  image: FileImage(_image),
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(roomName),
                    ],
                  )
                : Text(roomName)
            : Text("Room"),
      ),
      body: named
          ? imaged
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    children: [
                      Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Add your favorite person to room",
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.5)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: StreamBuilder<dynamic>(
                            stream: _firestore
                                .collection("Users")
                                .doc(_auth.currentUser!.uid)
                                .collection("Favorites")
                                .orderBy("time", descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              return snapshot.hasData
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: snapshot.data.docs.length,
                                      itemBuilder: (context, index) {
                                        return StreamBuilder<dynamic>(
                                            stream: _firestore
                                                .collection("Users")
                                                .doc(snapshot.data.docs[index]
                                                    ["id"])
                                                .snapshots(),
                                            builder: (context, snapshots) {
                                              if (snapshots.hasData) {
                                                Map<String, dynamic>? data =
                                                    snapshots.data.data();
                                                return data != null
                                                    ? ListItem(
                                                        name: snapshot.data
                                                                .docs[index]
                                                            ["name"],
                                                        id: snapshot.data
                                                            .docs[index]["id"],
                                                        uuid: widget.uuid,
                                                        profilePic: snapshot
                                                                .data
                                                                .docs[index]
                                                            ["profilePic"],
                                                        roomPic: roomPic,
                                                        roomName: roomName)
                                                    : ListItem(
                                                        name: snapshot.data
                                                                .docs[index]
                                                            ["name"],
                                                        id: snapshot.data
                                                            .docs[index]["id"],
                                                        uuid: widget.uuid,
                                                        profilePic: snapshot
                                                                .data
                                                                .docs[index]
                                                            ["profilePic"],
                                                        roomPic: roomPic,
                                                        roomName: roomName,
                                                      );
                                              } else {
                                                return SpinKitFadingCircle(
                                                    color: Color(0xFF2EF7F7));
                                              }
                                            });
                                      },
                                    )
                                  : SpinKitFadingCircle(
                                      color: Color(0xFF2EF7F7),
                                    );
                            },
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        height: 50.0,
                        child: InkWell(
                          onTap: () async {
                            await _firestore
                                .collection("Users")
                                .doc(_auth.currentUser!.uid)
                                .collection("InRoom")
                                .doc(widget.uuid)
                                .set({
                              "roomName": roomName,
                              "id": widget.uuid,
                              "time": DateTime.now(),
                              "roomPic": roomPic
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatDetail(
                                    name: roomName,
                                    userId: widget.uuid,
                                    group: true,
                                    profilePic: roomPic),
                              ),
                            );
                            _showToast("Friends are added to room");
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 20.0),
                            padding: const EdgeInsets.only(
                                left: 20.0,
                                top: 10.0,
                                right: 10.0,
                                bottom: 10.0),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Create',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w400),
                                ),
                                Icon(Icons.arrow_right)
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 160.0,
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: !picked
                                  ? Image(
                                      image: NetworkImage(
                                          "https://firebasestorage.googleapis.com/v0/b/textme-32c91.appspot.com/o/Status%2Favatar.png?alt=media&token=82fbbc78-7e2f-4f0a-9b38-d689e080913f"),
                                      height: 120,
                                      width: 120,
                                    )
                                  : Image(
                                      image: FileImage(_image),
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 100.0,
                          left: 210.0,
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
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    InkWell(
                      onTap: () async {
                        if (picked) {
                          print("Start");
                          await _storage
                              .ref()
                              .child("RoomPic")
                              .child(roomName)
                              .putFile(_image)
                              .then((value) {
                            if (value.state == TaskState.running) {}
                            if (value.state == TaskState.success) {
                              value.ref.getDownloadURL().then((value) async {
                                _showToast("Image Picked successfully.!");
                                setState(() {
                                  roomPic = value;

                                  imaged = true;
                                  named = true;
                                });
                              });
                            }
                          });
                          print("End");
                        } else {
                          _showToast("Please pick a picture for room");
                        }
                      },
                      child: Container(
                        height: 40.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.blue.withOpacity(0.4),
                        ),
                        child: Center(
                          child: Text(
                            "Save",
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    autofocus: true,
                    controller: _name,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: "Enter name for room",
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding:
                          const EdgeInsets.fromLTRB(13.0, 13.0, 13.0, 13.0),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 0.0000000001, color: Colors.black),
                          borderRadius: BorderRadius.circular(100.0)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 0.0000000001, color: Colors.white),
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  InkWell(
                    onTap: () {
                      if (_name.text == '') {
                        _showToast("Please enter name");
                      } else {
                        setState(() {
                          roomName = _name.text;
                          named = true;
                        });
                        _showToast("Named Successfully");
                      }
                    },
                    child: Container(
                      height: 40.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.blue.withOpacity(0.4),
                      ),
                      child: Center(
                        child: Text(
                          "Save",
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
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
          .getImage(source: ImageSource.gallery, imageQuality: 100);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          picked = true;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  _showToast(String msg) {
    Widget toast = Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.grey.withOpacity(0.5),
        ),
        child: Text(
          msg,
          style: TextStyle(fontWeight: FontWeight.w700),
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
          left: 0.0,
        );
      },
    );
  }
}

// ignore: must_be_immutable
class ListItem extends StatefulWidget {
  ListItem(
      {Key? key,
      required this.name,
      required this.id,
      required this.uuid,
      required this.profilePic,
      required this.roomPic,
      required this.roomName})
      : super(key: key);
  // ignore: non_constant_identifier_names
  late String name, id, roomName, profilePic, roomPic, uuid;

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem>
    with SingleTickerProviderStateMixin {
  _ListItemState();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool added = false;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetail(
              name: widget.name,
              userId: widget.id,
              group: false,
              profilePic: widget.roomPic,
            ),
          ),
        );
      },
      child: Container(
        height: widget.id != _auth.currentUser!.uid ? 75.0 : 0.0,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Hero(
                    tag: widget.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: widget.profilePic.isNotEmpty
                          ? CachedNetworkImage(
                              height: 49,
                              width: 49,
                              fit: BoxFit.cover,
                              imageUrl: widget.profilePic,
                              placeholder: (context, url) {
                                return Container(
                                  height: 100,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                            )
                          : Image(
                              image: AssetImage("assets/avatar.png"),
                              height: 49,
                              width: 49,
                            ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Text(
                      widget.name,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w800),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      setState(() {
                        added = !added;
                      });
                      print(widget.id);
                      added
                          ? await _firestore
                              .collection("Users")
                              .doc(widget.id)
                              .collection("InRoom")
                              .doc(widget.uuid)
                              .set({
                              "roomName": widget.roomName,
                              "id": widget.uuid,
                              "time": DateTime.now(),
                              "roomPic": widget.roomPic
                            })
                          : await _firestore
                              .collection("Users")
                              .doc(widget.id)
                              .collection("InRoom")
                              .doc(widget.uuid)
                              .delete();

                      added
                          ? _showToast(widget.name, "Added")
                          : _showToast(widget.name, "Removed");
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        width: 100,
                        height: 40,
                        color: added
                            ? Colors.red.withOpacity(0.2)
                            : Colors.green.withOpacity(0.2),
                        child: Center(
                          child: Text(
                            added ? "Remove" : "Add",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: added ? Colors.red : Colors.green,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Divider()
            ],
          ),
        ),
      ),
    );
  }

  _showToast(String name, String msg) {
    Widget toast = Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.grey.withOpacity(0.5),
        ),
        child: Text(
          name + " " + msg,
          style: TextStyle(fontWeight: FontWeight.w700),
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
          left: 0.0,
        );
      },
    );
  }
}
