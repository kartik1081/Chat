import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:textme/pages/chatpage.dart';

// ignore: must_be_immutable
class AddStatus extends StatefulWidget {
  AddStatus({Key? key, required this.image}) : super(key: key);
  late File image;

  @override
  _AddStatusState createState() => _AddStatusState();
}

class _AddStatusState extends State<AddStatus> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  late String url;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
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
              onTap: () async {
                print("Storage Start");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      index: 1,
                    ),
                  ),
                );

                await _storage
                    .ref()
                    .child("Status")
                    .child("${_auth.currentUser!.uid}")
                    .putFile(widget.image)
                    .then(
                  (value) {
                    value.ref.getDownloadURL().then(
                      (value) async {
                        var time = DateTime.now();
                        await _firestore
                            .collection("Status")
                            .doc("Status")
                            .set({"lastStatus": time});
                        await _firestore
                            .collection("Status")
                            .doc("Status")
                            .collection(_auth.currentUser!.uid)
                            .doc()
                            .set({"status": value, "time": time});
                        print("End");
                      },
                    );
                  },
                );
              },
              child: Container(
                margin: const EdgeInsets.all(10.0),
                height: 50.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35.0),
                    color: Color(0xFF6B5DAA)),
                child: Center(
                  child: Text(
                    "Share",
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 18.0),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
