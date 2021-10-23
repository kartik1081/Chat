import 'package:flutter/material.dart';
import 'package:textme/models/Providers/authentication_provider.dart';
import 'package:textme/models/services/fire.dart';
import 'package:textme/models/services/pageroute.dart';
import 'package:provider/provider.dart';

import 'chat.dart';
import 'room.dart';
import 'setting.dart';

// ignore: must_be_immutable
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
    Fire _fire = Fire();
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
                      "Room",
                      style: TextStyle(fontSize: 20.0),
                    ),
              actions: [
                _index == 0
                    ? PopupMenuButton(
                        elevation: 3.2,
                        onSelected: (int value) {
                          value == 0
                              ? Navigator.push(
                                  context,
                                  ScalePageRoute(widget: Setting(), out: false),
                                )
                              : value == 1
                                  ? context.watch().loggedIn
                                      ? context
                                          .read<Authentication>()
                                          .signOut(context)
                                      // ignore: unnecessary_statements
                                      : null
                                  // ignore: unnecessary_statements
                                  : null;
                        },
                        onCanceled: () {
                          print('You have not chossed anything');
                        },
                        tooltip: 'This is tooltip',
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem(
                            child: Text("Setting"),
                            value: 0,
                          ),
                          PopupMenuItem(
                            child: Text("Log Out"),
                            value: 1,
                          ),
                        ],
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
              children: [
                StreamProvider.value(
                    value: _fire.chatWithUserList(
                        context.watch<Authentication>().user.id),
                    initialData: [],
                    child: Chat()),
                ChatRoom()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
