// ignore: unused_import
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:textme/models/widgets/editprofiledetail.dart';
import 'package:textme/pages/signin.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
