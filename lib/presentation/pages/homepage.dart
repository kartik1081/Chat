import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/src/provider.dart';
import 'package:textme/models/Providers/list_provider.dart';

import 'chatpage.dart';
import 'profile.dart';
import 'search.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController controller = PageController();

  int _index = 0;
  List pages = [
    ChatPage(
      index: 0,
    ),
    Search(),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: PageView.builder(
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
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            backgroundBlendMode: BlendMode.darken,
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(0.1),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: GNav(
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
                    icon: LineIcons.home,
                    text: "Home",
                  ),
                  GButton(
                    icon: LineIcons.search,
                    text: "Search",
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
