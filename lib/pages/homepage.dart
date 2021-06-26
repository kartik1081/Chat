import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:textme/pages/chat.dart';
import 'package:textme/pages/profile.dart';
import 'package:textme/pages/setting.dart';

import 'search.dart';
import 'signin.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController controller = PageController();
  int _index = 0;
  List pages = [Chat(), Setting(), Profile()];
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: new AppBar(
            automaticallyImplyLeading: false,
            title: _index == 0
                ? new Text("Chat")
                : _index == 1
                    ? new Text("Setting")
                    : new Text("Profile"),
            actions: [
              _index == 0
                  ? new IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new Search(),
                              fullscreenDialog: true),
                        );
                      },
                      icon: new Icon(Icons.add),
                    )
                  : _index == 1
                      ? new Container()
                      : new IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => new SignIn(),
                              ),
                            );
                          },
                          icon: new Icon(Icons.logout),
                        ),
            ]),
        body: new PageView.builder(
          controller: controller,
          onPageChanged: (value) {
            setState(() {
              _index = value;
            });
          },
          itemCount: 3,
          itemBuilder: (context, index) {
            return pages[index];
          },
        ),
        bottomNavigationBar: new Container(
          decoration: new BoxDecoration(
            backgroundBlendMode: BlendMode.darken,
            color: Colors.transparent,
            boxShadow: [
              new BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(0.1),
              ),
            ],
          ),
          child: new SafeArea(
            child: new Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: new GNav(
                rippleColor: Color(0xFF2EF7F7),
                hoverColor: Color(0xFF2EF7F7),
                gap: 8,
                onTabChange: (value) {
                  setState(() {
                    _index = value;
                    controller.jumpToPage(value);
                  });
                },
                selectedIndex: _index,
                activeColor: Colors.white,
                iconSize: 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Color(0xFF7D1EF1),
                color: Colors.white,
                tabs: [
                  GButton(
                    icon: LineIcons.code,
                    text: "Chat",
                  ),
                  GButton(
                    icon: LineIcons.heart,
                    text: "Setting",
                  ),
                  GButton(
                    icon: LineIcons.user,
                    text: "Profile",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
