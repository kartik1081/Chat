import 'package:flutter/material.dart';
import 'package:textme/pages/setting.dart';
import 'package:textme/pages/status.dart';
import 'package:textme/pages/chat.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key? key, this.index}) : super(key: key);
  int? index;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  late TabController tab = TabController(length: 2, vsync: this);
  int? _index = 0;

  @override
  void initState() {
    super.initState();
    if (widget.index != 0) {
      setState(() {
        _index = widget.index;
      });
    }
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
        length: 2,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: _index == 0
                  ? Text(
                      "Chats",
                      style: TextStyle(fontSize: 20.0),
                    )
                  : Text(
                      "Status",
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
                    text: "Room",
                  ),
                ],
                indicatorColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
              ),
              automaticallyImplyLeading: false,
            ),
            body: TabBarView(
              controller: tab,
              children: [Chat(), Status()],
            ),
          ),
        ),
      ),
    );
  }
}
