import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:textme/models/services/fire.dart';

import 'signin.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late bool _loading;
  // ignore: unused_field
  final _form = GlobalKey<FormState>();
  Fire _fire = Fire();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    _loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color(0xFF6E00F3),
        body: _loading
            ? SpinKitFadingCircle(
                color: Color(0xFF2EF7F7),
                size: 50,
              )
            :
            // ignore: unrelated_type_equality_checks
            SizerUtil.orientation == Orientation.portrait
                ? Container(
                    height: height,
                    width: width,
                    child: Stack(
                      children: [
                        Positioned(
                          top: height * 0.17,
                          height: height * 40,
                          right: 20,
                          left: 20,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(40),
                            ),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200]!.withOpacity(0.8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[900]!.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Sign Up",
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[850]),
                                    ),
                                    SizedBox(
                                      height: 50,
                                    ),
                                    Form(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextFormField(
                                              keyboardType: TextInputType.name,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "Enter your name";
                                                }
                                              },
                                              controller: name,
                                              autofocus: true,
                                              autocorrect: true,
                                              cursorHeight: 22.0,
                                              decoration: InputDecoration(
                                                hintText: "Enter your name",
                                                hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                                fillColor: Colors.white,
                                                filled: true,
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        13.0, -5.0, 0.0, -5.0),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 0.0000000001,
                                                            color:
                                                                Colors.black),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    10.0)),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 0.0000000001,
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            TextFormField(
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "Enter your email";
                                                }
                                              },
                                              controller: email,
                                              cursorHeight: 22.0,
                                              autocorrect: true,
                                              decoration: InputDecoration(
                                                hintText: "Enter your email",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                fillColor: Colors.white,
                                                filled: true,
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        13.0, -5.0, 0.0, -5.0),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 0.0000000001,
                                                            color:
                                                                Colors.black),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    10.0)),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 0.0000000001,
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            TextFormField(
                                              obscureText: true,
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "Enter your password";
                                                }
                                              },
                                              controller: password,
                                              autocorrect: true,
                                              cursorHeight: 30.0,
                                              decoration: InputDecoration(
                                                hintText: "Enter your password",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                fillColor: Colors.white,
                                                filled: true,
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        13.0, -5.0, 0.0, -5.0),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 0.0000000001,
                                                            color:
                                                                Colors.black),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    10.0)),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 0.0000000001,
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Container(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: TextButton(
                                            child: Text(
                                              "Already have account",
                                              style: TextStyle(
                                                  fontSize: 11.0.sp,
                                                  color: Colors.black),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  // ignore: non_constant_identifier_names
                                                  builder: (BuildContext) =>
                                                      SignIn(),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 110,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          elevation:
                                              MaterialStateProperty.all(7),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.green),
                                          overlayColor:
                                              MaterialStateProperty.all(
                                                  Colors.lightGreen),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _loading = true;
                                          });
                                          _fire.signUp(context, name.text,
                                              email.text, password.text);
                                        },
                                        child: Text("Sign Up"),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.white),
                                                  elevation:
                                                      MaterialStateProperty.all(
                                                          7.0)),
                                              onPressed: () {
                                                setState(() {
                                                  _loading = true;
                                                });
                                                _fire.googleSignIn(context);
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Image.asset(
                                                      "assets/google.jpg"),
                                                  SizedBox(
                                                    width: 7.0,
                                                  ),
                                                  Text(
                                                    "Google",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 15.0),
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.blue),
                                                elevation:
                                                    MaterialStateProperty.all(
                                                        7.0),
                                              ),
                                              onPressed: () {
                                                // _flutterFire.signInWithFacebook(context);
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Icon(Icons.facebook),
                                                  SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  Text(
                                                    "Facebook",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : SafeArea(
                    child: Container(
                      height: height,
                      width: width,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 2.h,
                            height: 51.5.h,
                            right: 57.0.w,
                            left: 57.0.w,
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(40),
                              ),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200]!.withOpacity(0.8),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.grey[900]!.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 1.7.h,
                                      ),
                                      Text(
                                        "Sign Up",
                                        style: TextStyle(
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[850]),
                                      ),
                                      SizedBox(
                                        height: 3.h,
                                      ),
                                      Form(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextFormField(
                                                autocorrect: true,
                                                autofocus: true,
                                                keyboardType:
                                                    TextInputType.name,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Enter your name";
                                                  }
                                                },
                                                controller: name,
                                                decoration: InputDecoration(
                                                  hintText: "Enter your name",
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 10.0.sp),
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                    left: 13.0,
                                                    top: 8.0,
                                                    bottom: 8.0,
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  width:
                                                                      0.0000000001,
                                                                  color: Colors
                                                                      .black),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0)),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 0.0000000001,
                                                        color: Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 1.3.h,
                                              ),
                                              TextFormField(
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Enter your email";
                                                  }
                                                },
                                                controller: email,
                                                autocorrect: true,
                                                decoration: InputDecoration(
                                                  hintText: "Enter your email",
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 10.0.sp),
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          13.0, 8.0, 0.0, 8.0),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 0.0000000001,
                                                        color: Colors.black),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 0.0000000001,
                                                        color: Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 1.3.h,
                                              ),
                                              TextFormField(
                                                obscureText: true,
                                                keyboardType: TextInputType
                                                    .visiblePassword,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Enter your password";
                                                  }
                                                },
                                                controller: password,
                                                autocorrect: true,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      "Enter your password",
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 10.0.sp,
                                                  ),
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          13.0, 8.0, 0.0, 8.0),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 0.0000000001.w,
                                                        color: Colors.black),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 0.0000000001.w,
                                                        color: Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: Container(
                                          alignment: Alignment.bottomRight,
                                          child: Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: TextButton(
                                              child: Text(
                                                "Already have account",
                                                style: TextStyle(
                                                    fontSize: 10.0.sp,
                                                    color: Colors.black),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    // ignore: non_constant_identifier_names
                                                    builder: (BuildContext) =>
                                                        SignIn(),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 29.w,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            elevation:
                                                MaterialStateProperty.all(7),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.green),
                                            overlayColor:
                                                MaterialStateProperty.all(
                                                    Colors.lightGreen),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _loading = true;
                                            });
                                            _fire.signUp(context, name.text,
                                                email.text, password.text);
                                          },
                                          child: Text("Sign Up"),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 1.0.h,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.white),
                                                    elevation:
                                                        MaterialStateProperty
                                                            .all(7.0)),
                                                onPressed: () {
                                                  setState(() {
                                                    _loading = true;
                                                  });
                                                  _fire.googleSignIn(context);
                                                },
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Image.asset(
                                                        "assets/google.jpg"),
                                                    SizedBox(
                                                      width: 1.5.w,
                                                    ),
                                                    Text(
                                                      "Google",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4.0.w,
                                            ),
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.blue),
                                                  elevation:
                                                      MaterialStateProperty.all(
                                                          7.0),
                                                ),
                                                onPressed: () {
                                                  // _flutterFire.signInWithFacebook(context);
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Icon(Icons.facebook),
                                                    SizedBox(
                                                      width: 1.5.w,
                                                    ),
                                                    Text(
                                                      "Facebook",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
