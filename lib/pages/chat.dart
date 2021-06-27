import 'package:flutter/material.dart';
import 'package:textme/models/widgets/chatlist.dart';

class Chat extends StatefulWidget {
  Chat({
    Key? key,
  }) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // new SizedBox(
          //   height: 10,
          // ),
          // Status(),
          new SizedBox(
            height: 10,
          ),
          new ChatList()
        ],
      ),
    );
  }
}
