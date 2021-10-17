import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:textme/models/Providers/authentication_provider.dart';
import 'package:provider/provider.dart';
import 'package:textme/models/Providers/list_provider.dart';
import 'package:textme/models/services/fire.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Fire _fire = Fire();
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      context.read<Authentication>().loggedInUser(context);
      context.read<Authentication>().checkNetwork();
    });
    // print(context.watch<ListProvider>().allUsers);
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
