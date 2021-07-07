import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
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
    return WillPopScope(
      onWillPop: () async => false,
      child: DefaultTabController(
        length: 3,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: (_index == 0 &&
                          SizerUtil.orientation == Orientation.portrait) ||
                      (_index == 0 &&
                          SizerUtil.orientation == Orientation.landscape)
                  ? Text("Chat")
                  : (_index == 1 &&
                              SizerUtil.orientation == Orientation.portrait) ||
                          (_index == 1 &&
                              SizerUtil.orientation == Orientation.landscape)
                      ? Text("Status")
                      : Text("Calls"),
              actions: [
                _index == 0
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.search),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Search(),
                                    fullscreenDialog: true),
                              );
                            },
                            icon: Icon(Icons.add),
                          ),
                        ],
                      )
                    : _index == 1
                        ? IconButton(onPressed: () {}, icon: Icon(Icons.add))
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
                controller: tab, children: [Chat(), Status(), Calls()]),
          ),
        ),
      ),
    );
  }
}
