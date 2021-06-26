import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:textme/pages/chatdetail.dart';

class SearchUser extends StatefulWidget {
  const SearchUser({Key? key}) : super(key: key);

  @override
  _SearchUserState createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
      stream: _firestore
          .collection("Users")
          // .orderBy("time", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? new ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return new InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => new ChatDetail(
                            name: snapshot.data.docs[index]["name"],
                            userId: snapshot.data.docs[index]["id"],
                            profilePic: snapshot.data.docs[index]["profilePic"],
                          ),
                        ),
                      );
                    },
                    child: new Container(
                      height: snapshot.data.docs[index]["id"] !=
                              _auth.currentUser!.uid
                          ? 75.0
                          : 0.0,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 10.0),
                        child: Column(
                          children: [
                            new Row(
                              children: [
                                new Hero(
                                  tag: snapshot.data.docs[index]["id"],
                                  child: new ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: snapshot
                                            .data
                                            .docs[index]["profilePic"]
                                            .isNotEmpty
                                        ? new CachedNetworkImage(
                                            height: 49,
                                            width: 49,
                                            fit: BoxFit.cover,
                                            imageUrl: snapshot.data.docs[index]
                                                ["profilePic"],
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
                                            height: 49,
                                            width: 49,
                                          ),
                                  ),
                                ),
                                new SizedBox(
                                  width: 10.0,
                                ),
                                new Expanded(
                                  child: new Text(
                                    "${snapshot.data.docs[index]["name"]}",
                                    style: new TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                                new InkWell(
                                  onTap: () async {
                                    await _firestore
                                        .collection("Users")
                                        .doc(_auth.currentUser!.uid)
                                        .collection("Favorites")
                                        .doc(snapshot.data.docs[index]["id"])
                                        .set({
                                      "name": snapshot.data.docs[index]["name"],
                                      "profilePic": snapshot.data.docs[index]
                                          ["profilePic"],
                                      "time": DateTime.now(),
                                      "id": snapshot.data.docs[index]["id"],
                                    });
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: new Container(
                                      width: 100,
                                      height: 40,
                                      decoration: new BoxDecoration(
                                          color: Color(0xFF1D1A2B)),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          new Text(
                                            "add",
                                            style: new TextStyle(
                                                color: Colors.green),
                                          ),
                                          new Icon(Icons.add,
                                              color: Colors.green),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            new Divider()
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : new SpinKitFadingCircle(color: Color(0xFF2EF7F7));
      },
    );
  }
}
