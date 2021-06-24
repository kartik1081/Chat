import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:textme/pages/chatdetail.dart';

class SearchUser extends StatelessWidget {
  const SearchUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    FirebaseAuth _auth = FirebaseAuth.instance;
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
                  // if (snapshot.data.docs[index]["id"] == _auth.currentUser!.uid){
                  //   continue;
                  // }
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: new Column(
                        children: [
                          new ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => new ChatDetail(
                                    name: snapshot.data.docs[index]["name"],
                                    userId: snapshot.data.docs[index]["id"],
                                    profilePic: snapshot.data.docs[index]
                                        ["profilePic"],
                                  ),
                                ),
                              );
                            },
                            leading: new ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: snapshot
                                      .data.docs[index]["profilePic"].isNotEmpty
                                  ? new CachedNetworkImage(
                                      height: 55,
                                      width: 55,
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
                                      image: AssetImage("assets/avatar.png"),
                                      height: 50,
                                      width: 50,
                                    ),
                            ),
                            title: new Text(
                              "${snapshot.data.docs[index]["name"]}",
                              style: new TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800),
                            ),
                            trailing: new InkWell(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: new Container(
                                  width: 100,
                                  height: 40,
                                  decoration: new BoxDecoration(
                                      color: Color(0xFF1D1A2B)),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      new Text(
                                        "add",
                                        style:
                                            new TextStyle(color: Colors.green),
                                      ),
                                      new Icon(Icons.add, color: Colors.green),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          new Container(
                            height: 10.0,
                          )
                        ],
                      ),
                    );
                  },
                )
              : new SpinKitFadingCircle(color: Color(0xFF2EF7F7));
        });
  }
}
