import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:textme/models/services/fire.dart';

import 'signup.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late bool _loading;
  final _form = GlobalKey<FormState>();
  Fire _fire = Fire();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _loading = false;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: Color(0xFF6E00F3),
            body: _loading
                ? SpinKitFadingCircle(
                    color: Color(0xFF2EF7F7),
                    size: 50,
                  )
                : SingleChildScrollView(
                    child: SizerUtil.deviceType == DeviceType.mobile
                        ? Container(
                            height: height,
                            width: width,
                            child: Stack(
                              children: [
                                Positioned(
                                  top: height * 0.25,
                                  height: height * 40,
                                  right: 20,
                                  left: 20,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(40),
                                    ),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 5, sigmaY: 5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200]!
                                              .withOpacity(0.8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey[900]!
                                                  .withOpacity(0.5),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0, 2),
                                            )
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              "Sign In",
                                              style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey[850],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 50,
                                            ),
                                            Form(
                                              key: _form,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    TextFormField(
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Enter your email";
                                                        }
                                                      },
                                                      controller: email,
                                                      cursorHeight: 22.0,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            "Enter your email",
                                                        hintStyle: TextStyle(
                                                            color: Colors.grey),
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                13.0,
                                                                -5.0,
                                                                0.0,
                                                                -5.0),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              width:
                                                                  0.0000000001,
                                                              color:
                                                                  Colors.black),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            width: 0.0000000001,
                                                            color: Colors.white,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            10.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10.0,
                                                    ),
                                                    TextFormField(
                                                      obscureText: true,
                                                      keyboardType:
                                                          TextInputType
                                                              .visiblePassword,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Enter your password";
                                                        }
                                                      },
                                                      controller: password,
                                                      cursorHeight: 30.0,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            "Enter your password",
                                                        hintStyle: TextStyle(
                                                            color: Colors.grey),
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                13.0,
                                                                -5.0,
                                                                0.0,
                                                                -5.0),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(
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
                                                              width:
                                                                  0.0000000001,
                                                              color:
                                                                  Colors.white),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20),
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  child: TextButton(
                                                    child: Text(
                                                      "Create account",
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          // ignore: non_constant_identifier_names
                                                          builder:
                                                              (BuildContext) =>
                                                                  SignUp(),
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
                                                      MaterialStateProperty.all(
                                                          7),
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
                                                  _fire.signIn(
                                                      context,
                                                      email.text,
                                                      password.text);
                                                },
                                                child: Text("Sign In"),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 25,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                                                .all(Colors
                                                                    .white),
                                                        elevation:
                                                            MaterialStateProperty
                                                                .all(7.0),
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          _loading = true;
                                                        });
                                                        _fire.googleSignIn(
                                                            context);
                                                      },
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Image.asset(
                                                              "assets/google.jpg"),
                                                          SizedBox(
                                                            width: 7.0,
                                                          ),
                                                          Text(
                                                            "Google",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .blue),
                                                        elevation:
                                                            MaterialStateProperty
                                                                .all(7.0),
                                                      ),
                                                      onPressed: () {
                                                        // _flutterFire.signInWithFacebook(context);
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Icon(Icons.facebook),
                                                          SizedBox(
                                                            width: 5.0,
                                                          ),
                                                          Text(
                                                            "Facebook",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                        : Container(
                            height: height,
                            width: width,
                            child: Stack(
                              children: [
                                Positioned(
                                  top: height * 0.25,
                                  height: height * 40,
                                  right: 20,
                                  left: 20,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(40),
                                    ),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 5, sigmaY: 5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200]!
                                              .withOpacity(0.8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey[900]!
                                                  .withOpacity(0.5),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0, 2),
                                            )
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              "Sign In",
                                              style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey[850],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 50,
                                            ),
                                            Form(
                                              key: _form,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    TextFormField(
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Enter your email";
                                                        }
                                                      },
                                                      controller: email,
                                                      cursorHeight: 22.0,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            "Enter your email",
                                                        hintStyle: TextStyle(
                                                            color: Colors.grey),
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                13.0,
                                                                -5.0,
                                                                0.0,
                                                                -5.0),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              width:
                                                                  0.0000000001,
                                                              color:
                                                                  Colors.black),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            width: 0.0000000001,
                                                            color: Colors.white,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            10.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10.0,
                                                    ),
                                                    TextFormField(
                                                      obscureText: true,
                                                      keyboardType:
                                                          TextInputType
                                                              .visiblePassword,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Enter your password";
                                                        }
                                                      },
                                                      controller: password,
                                                      cursorHeight: 30.0,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            "Enter your password",
                                                        hintStyle: TextStyle(
                                                            color: Colors.grey),
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                13.0,
                                                                -5.0,
                                                                0.0,
                                                                -5.0),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(
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
                                                              width:
                                                                  0.0000000001,
                                                              color:
                                                                  Colors.white),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20),
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  child: TextButton(
                                                    child: Text(
                                                      "Create account",
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          // ignore: non_constant_identifier_names
                                                          builder:
                                                              (BuildContext) =>
                                                                  SignUp(),
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
                                                      MaterialStateProperty.all(
                                                          7),
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
                                                  _fire.signIn(
                                                      context,
                                                      email.text,
                                                      password.text);
                                                },
                                                child: Text("Sign In"),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 25,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                                                .all(Colors
                                                                    .white),
                                                        elevation:
                                                            MaterialStateProperty
                                                                .all(7.0),
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          _loading = true;
                                                        });
                                                        _fire.googleSignIn(
                                                            context);
                                                      },
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Image.asset(
                                                              "assets/google.jpg"),
                                                          SizedBox(
                                                            width: 7.0,
                                                          ),
                                                          Text(
                                                            "Google",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .blue),
                                                        elevation:
                                                            MaterialStateProperty
                                                                .all(7.0),
                                                      ),
                                                      onPressed: () {
                                                        // _flutterFire.signInWithFacebook(context);
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Icon(Icons.facebook),
                                                          SizedBox(
                                                            width: 5.0,
                                                          ),
                                                          Text(
                                                            "Facebook",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
      },
    );
  }
}
