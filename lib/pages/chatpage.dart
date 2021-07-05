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
    return WillPopScope(
      onWillPop: () async => false,
      child: DefaultTabController(
        length: 3,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: _index == 0
                  ? TweenAnimationBuilder(
                      child: Text("Chat"),
                      duration: Duration(milliseconds: 1000),
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      builder: (BuildContext context, double value, child) {
                        return Opacity(
                          opacity: value,
                          child: child,
                        );
                      },
                    )
                  : _index == 1
                      ? TweenAnimationBuilder(
                          child: Text("Status"),
                          duration: Duration(milliseconds: 1000),
                          tween: Tween<double>(begin: 0.0, end: 1.0),
                          builder: (BuildContext context, double value, child) {
                            return Opacity(
                              opacity: value,
                              child: child,
                            );
                          },
                        )
                      : TweenAnimationBuilder(
                          child: Text("Calls"),
                          duration: Duration(milliseconds: 1000),
                          tween: Tween<double>(begin: 0.0, end: 1.0),
                          builder: (BuildContext context, double value, child) {
                            return Opacity(
                              opacity: value,
                              child: child,
                            );
                          },
                        ),
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
