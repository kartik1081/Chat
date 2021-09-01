import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:textme/models/services/pageroute.dart';

import 'homepage.dart';
import 'signin.dart';

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
    // _auth.authStateChanges().listen((event) {
    //   event != null
    //       ? Navigator.push(
    //           context, SlidePageRoute(widget: HomePage(), direction: "right"))
    //       : event == null
    //           ? Navigator.push(
    //               context, SlidePageRoute(widget: SignIn(), direction: "left"))
    //           : Navigator.pop(context);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Text",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF2EF7F7),
                    ),
                  ),
                  Text(
                    "Me",
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF7D1EF1)),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 200.0,
              height: 50.0,
              child: Shimmer.fromColors(
                baseColor: Color(0xFF31444B),
                highlightColor: Color(0xFF618A99),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(100.0)),
                      height: 10.0,
                      width: 10.0,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(100.0)),
                      height: 10.0,
                      width: 10.0,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(100.0)),
                      height: 10.0,
                      width: 10.0,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(100.0)),
                      height: 10.0,
                      width: 10.0,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(100.0)),
                      height: 10.0,
                      width: 10.0,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
