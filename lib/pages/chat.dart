import 'package:flutter/material.dart';
import 'package:textme/models/widgets/chatlist.dart';
import 'package:textme/models/widgets/status.dart';
import 'package:textme/pages/search.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        title: new Text("Chat"),
        actions: [
          new IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new Search(), fullscreenDialog: true),
              );
            },
            icon: new Icon(Icons.add),
          ),
        ],
      ),
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
