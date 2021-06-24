import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:textme/pages/homepage.dart';
import 'package:textme/pages/signin.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      _auth.authStateChanges().listen((event) {
        if (event != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => new HomePage(),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => new SignIn(),
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2B2641),
      body: new SafeArea(
        child: new Column(
          children: [
            new Expanded(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Text(
                    "Text",
                    style: new TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF2EF7F7),
                    ),
                  ),
                  new Text(
                    "Me",
                    style: new TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF7D1EF1)),
                  ),
                ],
              ),
            ),
            new SpinKitFadingCircle(color: Color(0xFF2EF7F7)),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
