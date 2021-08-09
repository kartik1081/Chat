// ignore: unused_import
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:textme/models/services/fire.dart';
import 'package:textme/pages/signin.dart';

import 'editprofile.dart';
import 'favorites.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Fire _fire = Fire();
  late FToast fToast;
  bool net = false;

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((event) {
      switch (event) {
        case ConnectivityResult.mobile:
          setState(() {
            net = true;
          });
          _showToast("Connection successfully");
          print(net);
          break;
        case ConnectivityResult.wifi:
          setState(() {
            net = true;
          });
          _showToast("Connection successfully");
          print(net);
          break;
        default:
          setState(() {
            net = false;
          });
          _showToast("Check connection");
          print(net);
          break;
      }
    });
    fToast = FToast();
    fToast.init(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Profile"),
        actions: [
          IconButton(
            onPressed: () {
              if (_auth.currentUser != null) {
                if (net) {
                  _fire.signOut(context).whenComplete(() => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignIn(),
                        ),
                      ));
                } else {
                  _showToast("Check connections");
                }
              } else {
                null;
              }
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                color: Colors.white.withOpacity(0.7),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StreamBuilder<dynamic>(
                    stream: _firestore
                        .collection("Users")
                        .doc("${_auth.currentUser!.uid}")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Map<String, dynamic> data = snapshot.data.data();
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: data["profilePic"].isNotEmpty
                                  ? CachedNetworkImage(
                                      height: 65,
                                      width: 65,
                                      fit: BoxFit.cover,
                                      imageUrl: data["profilePic"],
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
                                      height: 65,
                                      width: 65,
                                    ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data["name"],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800),
                                ),
                                Text(
                                  data["email_phone"],
                                  style: TextStyle(
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
                      return CircularProgressIndicator();
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 300,
                    decoration: BoxDecoration(),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfile(),
                              fullscreenDialog: true),
                        );
                      },
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.favorite, color: Colors.red.withOpacity(0.6)),
              title: Text(
                "Favorites",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Favorites()));
              },
            )
          ],
        ),
      ),
    );
  }

  _showToast(String msg) {
    Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.white.withOpacity(0.65),
        ),
        child: Text(msg));

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 3),
    );
  }
}
