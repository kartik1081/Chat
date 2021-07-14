import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:textme/pages/chatpage.dart';

// ignore: must_be_immutable
class StatusDetail extends StatefulWidget {
  StatusDetail({Key? key, required this.userID}) : super(key: key);
  String userID;

  @override
  _StatusDetailState createState() => _StatusDetailState();
}

class _StatusDetailState extends State<StatusDetail> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final controller = StoryController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<StoryItem> storyItems = [
      StoryItem.text(
          title: '''“When you talk, you are only repeating something you know.
       But if you listen, you may learn something new.” 
       – Dalai Lama''', backgroundColor: Colors.blueGrey),
      StoryItem.pageImage(
          url:
              "https://images.unsplash.com/photo-1553531384-cc64ac80f931?ixid=MnwxMjA3fDF8MHxzZWFyY2h8MXx8bW91bnRhaW58ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
          controller: controller),
      StoryItem.pageImage(
          url: "https://wp-modula.com/wp-content/uploads/2018/12/gifgif.gif",
          controller: controller,
          imageFit: BoxFit.contain),
    ];
    return WillPopScope(
      onWillPop: () async => true,
      child: Material(
        child: StreamBuilder<dynamic>(
            stream:
                _firestore.collection("Users").where("profilePic").snapshots(),
            builder: (context, snapshot) {
              return StoryView(
                storyItems: storyItems,
                controller: controller,
                progressPosition: ProgressPosition.top,
                inline: false,
                repeat: false,
                onComplete: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
