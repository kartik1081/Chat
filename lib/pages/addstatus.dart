import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddStatus extends StatefulWidget {
  AddStatus({Key? key, required this.image, required this.url})
      : super(key: key);
  late File image;
  late String? url;

  @override
  _AddStatusState createState() => _AddStatusState();
}

class _AddStatusState extends State<AddStatus> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: Center(
                child: Image(
                  image: FileImage(
                    widget.image,
                  ),
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async => await _firestore
                .collection("Users")
                .doc("${_auth.currentUser!.uid}")
                .update({
              "profilePic": widget.url,
            }),
            child: Container(
              margin: const EdgeInsets.all(10.0),
              height: 50.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35.0),
                  color: Color(0xFF6B5DAA)),
              child: Center(
                child: Text(
                  "Send",
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
