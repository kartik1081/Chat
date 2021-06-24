import 'package:flutter/material.dart';
import 'package:textme/models/widgets/editprofiledetail.dart';
import 'package:textme/pages/signin.dart';

class Profile extends StatelessWidget {
  Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: new Text("Profile"),
        actions: [
          new IconButton(
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
        ],
      ),
      body: new SafeArea(
        child: new Stack(
          children: [
            new Positioned(
              top: 10.0,
              left: 10.0,
              right: 10.0,
              height: MediaQuery.of(context).size.height * 0.3,
              child: EditProfileDetail(),
            )
          ],
        ),
      ),
    );
  }
}
