import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textme/pages/addstatus.dart';
import 'package:textme/pages/setting.dart';
import 'package:textme/pages/status.dart';
import 'package:textme/pages/call.dart';
import 'package:textme/pages/chat.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  late TabController tab = TabController(length: 3, vsync: this);
  int _index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    tab.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: DefaultTabController(
        length: 3,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: _index == 0
                  ? Text(
                      "Chats",
                      style: TextStyle(fontSize: 20.0),
                    )
                  : _index == 1
                      ? Text(
                          "Status",
                          style: TextStyle(fontSize: 20.0),
                        )
                      : Text(
                          "Calls",
                          style: TextStyle(fontSize: 20.0),
                        ),
              actions: [
                _index == 0
                    ? IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Setting(),
                            ),
                          );
                        },
                        icon: Icon(Icons.more_vert),
                      )
                    : Container()
              ],
              bottom: TabBar(
                controller: tab,
                onTap: (value) {
                  setState(() {
                    _index = value;
                  });
                },
                tabs: [
                  Tab(
                    text: "Chat",
                  ),
                  Tab(
                    text: "Status",
                  ),
                  Tab(
                    text: "Calls",
                  )
                ],
                indicatorColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
              ),
              automaticallyImplyLeading: false,
            ),
            body: TabBarView(
              controller: tab,
              children: [Chat(), Status(), Calls()],
            ),
          ),
        ),
      ),
    );
  }
}
