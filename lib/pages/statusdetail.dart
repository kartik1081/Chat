import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:story_view/story_view.dart';
import 'package:textme/pages/homepage.dart';

// ignore: must_be_immutable
class StatusDetail extends StatefulWidget {
  StatusDetail({Key? key, required this.userID, required this.profilePic})
      : super(key: key);
  String userID, profilePic;

  @override
  _StatusDetailState createState() => _StatusDetailState();
}

class _StatusDetailState extends State<StatusDetail> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final controller = StoryController();
  List<StoryItem> storyList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Material(
        child: Stack(
          children: [
            StreamBuilder<dynamic>(
              stream: _firestore
                  .collection("Status")
                  .where("id", isEqualTo: widget.userID)
                  .snapshots(),
              builder: (context, snapshot) {
                for (var i in snapshot.data.docs) {
                  storyList.add(
                    StoryItem.pageImage(
                        url: i["status"], controller: controller),
                  );
                }
                return snapshot.hasData
                    ? StoryView(
                        storyItems: storyList.length != 0
                            ? storyList
                            : [
                                StoryItem.text(
                                  title: "No Story",
                                  backgroundColor: Color(0xFF2B2641),
                                ),
                              ],
                        controller: controller,
                        progressPosition: ProgressPosition.top,
                        inline: false,
                        repeat: false,
                        onComplete: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        },
                      )
                    : SpinKitFadingCircle(
                        color: Color(0xFF2EF7F7),
                        size: 50,
                      );
              },
            ),
            Positioned(
              top: 40.0,
              left: 20.0,
              child: Container(
                alignment: Alignment.centerLeft,
                height: 70.0,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Hero(
                      tag: widget.userID,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: CachedNetworkImage(
                          height: 55,
                          width: 55,
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
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    StreamBuilder<dynamic>(
                        stream: _firestore
                            .collection("Users")
                            .doc(widget.userID)
                            .snapshots(),
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? Text(
                                  snapshot.data["name"],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              : Text(
                                  "Name",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                );
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  show(
    String url,
  ) {
    return StoryItem.pageImage(url: url, controller: controller);
  }
}
