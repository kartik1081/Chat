import 'package:flutter/material.dart';
import 'package:textme/models/services/pageroute.dart';
import 'package:textme/pages/homepage.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context, ScalePageRoute(widget: HomePage(), out: true));
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          ListTile(
            leading: Icon(
              Icons.vpn_key,
              color: Colors.white,
            ),
            title: Text(
              "Account",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              "Privacy, security, change number",
              style: TextStyle(
                color: Colors.white60,
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.chat,
              color: Colors.white,
            ),
            title: Text(
              "Chats",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              "Themes, wallpapers, chat history",
              style: TextStyle(
                color: Colors.white60,
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            title: Text(
              "Notifications",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              "Message, group & call tones",
              style: TextStyle(
                color: Colors.white60,
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.storage_rounded,
              color: Colors.white,
            ),
            title: Text(
              "Stirage abd data",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              "Network usage, auto-download",
              style: TextStyle(
                color: Colors.white60,
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.help,
              color: Colors.white,
            ),
            title: Text(
              "Help",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              "Help centre, contact us, privacy policy",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.add_to_photos_rounded,
              color: Colors.white,
            ),
            title: Text(
              "Invite a friend",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Divider(),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Form",
                  style: TextStyle(color: Colors.grey, fontSize: 15.0),
                ),
                SizedBox(
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
