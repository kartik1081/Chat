import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        title: new Text("Setting"),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          new ListTile(
            leading: new Icon(
              Icons.vpn_key,
              color: Colors.white,
            ),
            title: new Text(
              "Account",
              style: new TextStyle(
                color: Colors.white,
              ),
            ),
            subtitle: new Text(
              "Privacy, security, change number",
              style: new TextStyle(
                color: Colors.white60,
              ),
            ),
          ),
          new Divider(),
          new ListTile(
            leading: new Icon(
              Icons.chat,
              color: Colors.white,
            ),
            title: new Text(
              "Chats",
              style: new TextStyle(
                color: Colors.white,
              ),
            ),
            subtitle: new Text(
              "Themes, wallpapers, chat history",
              style: new TextStyle(
                color: Colors.white60,
              ),
            ),
          ),
          new Divider(),
          new ListTile(
            leading: new Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            title: new Text(
              "Notifications",
              style: new TextStyle(
                color: Colors.white,
              ),
            ),
            subtitle: new Text(
              "Message, group & call tones",
              style: new TextStyle(
                color: Colors.white60,
              ),
            ),
          ),
          new Divider(),
          new ListTile(
            leading: new Icon(
              Icons.storage_rounded,
              color: Colors.white,
            ),
            title: new Text(
              "Stirage abd data",
              style: new TextStyle(
                color: Colors.white,
              ),
            ),
            subtitle: new Text(
              "Network usage, auto-download",
              style: new TextStyle(
                color: Colors.white60,
              ),
            ),
          ),
          new Divider(),
          new ListTile(
            leading: new Icon(
              Icons.help,
              color: Colors.white,
            ),
            title: new Text(
              "Help",
              style: new TextStyle(
                color: Colors.white,
              ),
            ),
            subtitle: new Text(
              "Help centre, contact us, privacy policy",
              style: new TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          new Divider(),
          new ListTile(
            leading: new Icon(
              Icons.add_to_photos_rounded,
              color: Colors.white,
            ),
            title: new Text(
              "Invite a friend",
              style: new TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          new Divider(),
          new Expanded(
            child: new Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Text(
                  "Form",
                  style: new TextStyle(color: Colors.grey, fontSize: 15.0),
                ),
                new SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
