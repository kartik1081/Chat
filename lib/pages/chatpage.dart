import 'package:flutter/material.dart';
import 'package:textme/pages/status.dart';
import 'package:textme/pages/call.dart';
import 'package:textme/pages/chat.dart';
import 'package:textme/pages/search.dart';

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
    return new DefaultTabController(
      length: 3,
      child: new SafeArea(
        child: new Scaffold(
          appBar: new AppBar(
            title: _index == 0
                ? new Text("Chat")
                : _index == 1
                    ? new Text("Status")
                    : new Text("Calls"),
            actions: [
              _index == 0
                  ? new Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        new IconButton(
                          onPressed: () {},
                          icon: new Icon(Icons.search),
                        ),
                        new IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new Search(),
                                  fullscreenDialog: true),
                            );
                          },
                          icon: new Icon(Icons.add),
                        ),
                      ],
                    )
                  : _index == 1
                      ? new IconButton(
                          onPressed: () {}, icon: new Icon(Icons.add))
                      : new Container()
            ],
            bottom: new TabBar(
              controller: tab,
              onTap: (value) {
                setState(() {
                  _index = value;
                });
              },
              tabs: [
                new Tab(
                  text: "Chat",
                ),
                new Tab(
                  text: "Status",
                ),
                new Tab(
                  text: "Calls",
                )
              ],
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            automaticallyImplyLeading: false,
          ),
          body: new TabBarView(
              controller: tab, children: [Chat(), Status(), Calls()]),
        ),
      ),
    );
  }
}
