import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:textme/models/services/fire.dart';

import 'signup.dart';

class WithEmail extends StatefulWidget {
  @override
  _WithEmailState createState() => _WithEmailState();
}

class _WithEmailState extends State<WithEmail> {
  late bool _loading;
  final _form = GlobalKey<FormState>();
  Fire _fire = Fire();
  bool _withEmail = true;
  Icon _with = Icon(
    Icons.phone_android,
    color: Colors.black,
  );
  bool _sent = false;
  late FToast fToast;
  // ignore: non_constant_identifier_names
  TextEditingController email_phone = TextEditingController();
  TextEditingController password = TextEditingController();
  late FocusNode emailNode = FocusNode();
  late FocusNode passwordNode = FocusNode();
  late FocusNode signInNode = FocusNode();

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _loading = false;
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => false,
      child: Sizer(
        builder: (context, orientation, deviceType) => Scaffold(
          backgroundColor: Color(0xFF6E00F3),
          body: _loading
              ? SpinKitFadingCircle(
                  color: Color(0xFF2EF7F7),
                  size: 50,
                )
              : SizerUtil.orientation == Orientation.portrait
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
                                Radius.circular(40.sp),
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
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "Sign In",
                                        style: TextStyle(
                                          fontSize: 30.sp,
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: TextFormField(
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return _withEmail
                                                          ? "Enter your email"
                                                          : "Enter your number";
                                                    }
                                                  },
                                                  controller: email_phone,
                                                  focusNode: emailNode,
                                                  onFieldSubmitted: (value) {
                                                    emailNode.unfocus();
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            passwordNode);
                                                  },
                                                  autocorrect: true,
                                                  autofocus: true,
                                                  decoration: InputDecoration(
                                                    hintText: _withEmail
                                                        ? "Enter your email"
                                                        : "Enter your number",
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey),
                                                    fillColor: Colors.white,
                                                    filled: true,
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .fromLTRB(13.0,
                                                            -5.0, 0.0, -5.0),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: 0.0000000001,
                                                          color: Colors.black),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0.sp),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        width: 0.0000000001,
                                                        color: Colors.white,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        10.0.sp,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              TextFormField(
                                                obscureText: true,
                                                keyboardType: TextInputType
                                                    .visiblePassword,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return _withEmail
                                                        ? "Enter your password"
                                                        : "Enter your OTP";
                                                  }
                                                },
                                                controller: password,
                                                focusNode: passwordNode,
                                                onFieldSubmitted: (value) {
                                                  passwordNode.unfocus();
                                                  FocusScope.of(context)
                                                      .requestFocus(signInNode);
                                                },
                                                autocorrect: true,
                                                decoration: InputDecoration(
                                                  hintText: _withEmail
                                                      ? "Enter your password"
                                                      : "Enter your OTP",
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey),
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          13.0,
                                                          -5.0,
                                                          0.0,
                                                          -5.0),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              width:
                                                                  0.0000000001,
                                                              color: Colors
                                                                  .black),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0.sp)),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 0.0000000001,
                                                        color: Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0.sp),
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
                                                "Create account",
                                                style: TextStyle(
                                                    fontSize: 11.0.sp,
                                                    color: Colors.black),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder:
                                                        // ignore: non_constant_identifier_names
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
                                        width: 115,
                                        child: ElevatedButton(
                                          focusNode: signInNode,
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
                                            if (_withEmail) {
                                              if (email_phone.text
                                                  .endsWith("@gmail.com")) {
                                                setState(() {
                                                  _loading = true;
                                                });
                                                _fire.signIn(
                                                    context,
                                                    email_phone.text,
                                                    password.text);
                                              } else {
                                                _showToast(
                                                    "Pleas enter valid email");
                                              }
                                            } else if (!_withEmail) {
                                              if (email_phone.text.length ==
                                                  10) {
                                              } else {
                                                _showToast(
                                                    "Pleas enter valid number");
                                              }
                                            }
                                          },
                                          child: Text(!_withEmail && !_sent
                                              ? "OTP Request"
                                              : "Sign In"),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.white),
                                                  elevation:
                                                      MaterialStateProperty.all(
                                                          7.0)),
                                              onPressed: () {
                                                setState(() {
                                                  if (_withEmail) {
                                                    setState(() {
                                                      _withEmail = false;
                                                      _with = Icon(
                                                        Icons.email,
                                                        color: Colors.black,
                                                      );
                                                    });
                                                    _showToast(
                                                        "Sign In with number");
                                                  } else if (!_withEmail) {
                                                    setState(() {
                                                      _withEmail = true;
                                                      _with = Icon(
                                                        Icons.phone_android,
                                                        color: Colors.black,
                                                      );
                                                    });
                                                    _showToast(
                                                        "Sign In with number");
                                                  }
                                                });
                                              },
                                              child: _with,
                                            ),
                                            SizedBox(width: 15.0),
                                            ElevatedButton(
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
                                              child: Image.asset(
                                                  "assets/google.jpg"),
                                            ),
                                            SizedBox(width: 15.0),
                                            ElevatedButton(
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
                                              child: Icon(Icons.facebook),
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
                              top: 8.h,
                              height: 46.5.h,
                              right: 57.0.w,
                              left: 57.0.w,
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(40.sp),
                                ),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200]!.withOpacity(0.8),
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
                                          height: 1.7.h,
                                        ),
                                        Text(
                                          "Sign In",
                                          style: TextStyle(
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[850],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3.h,
                                        ),
                                        Form(
                                          key: _form,
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
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return "Enter your email";
                                                    }
                                                  },
                                                  controller: email_phone,
                                                  focusNode: emailNode,
                                                  onFieldSubmitted: (value) {
                                                    emailNode.unfocus();
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            passwordNode);
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Enter your email",
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 10.0.sp),
                                                    fillColor: Colors.white,
                                                    filled: true,
                                                    isDense: true,
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .fromLTRB(13.0,
                                                            8.0, 0.0, 8.0),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: 0.0000000001,
                                                          color: Colors.black),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0.sp),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        width: 0.0000000001,
                                                        color: Colors.white,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        10.0.sp,
                                                      ),
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
                                                  focusNode: passwordNode,
                                                  onFieldSubmitted: (value) {
                                                    signInNode.unfocus();
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            emailNode);
                                                  },
                                                  autocorrect: true,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Enter your password",
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 10.0.sp),
                                                    fillColor: Colors.white,
                                                    filled: true,
                                                    isDense: true,
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .fromLTRB(13.0,
                                                            8.0, 0.0, 8.0),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                width:
                                                                    0.0000000001
                                                                        .w,
                                                                color: Colors
                                                                    .black),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0.sp)),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: 0.0000000001,
                                                          color: Colors.white),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0.sp),
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
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              child: TextButton(
                                                child: Text(
                                                  "Create account",
                                                  style: TextStyle(
                                                      fontSize: 10.0.sp,
                                                      color: Colors.black),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder:
                                                          // ignore: non_constant_identifier_names
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
                                            focusNode: signInNode,
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
                                              _fire.signIn(
                                                  context,
                                                  email_phone.text,
                                                  password.text);
                                            },
                                            child: Text("Sign In"),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.white),
                                                    elevation:
                                                        MaterialStateProperty
                                                            .all(7.0)),
                                                onPressed: () {
                                                  setState(() {
                                                    _withEmail
                                                        ? setState(() {
                                                            _withEmail = false;
                                                            _with = Icon(
                                                              Icons.email,
                                                              color:
                                                                  Colors.black,
                                                            );
                                                          })
                                                        : setState(() {
                                                            _withEmail = true;
                                                            _with = Icon(
                                                              Icons
                                                                  .phone_android,
                                                              color:
                                                                  Colors.black,
                                                            );
                                                          });
                                                  });
                                                },
                                                child: _with,
                                              ),
                                              SizedBox(width: 15.0),
                                              ElevatedButton(
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
                                                child: Image.asset(
                                                    "assets/google.jpg"),
                                              ),
                                              SizedBox(width: 15.0),
                                              ElevatedButton(
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
                                                child: Icon(Icons.facebook),
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
      ),
    );
  }

  _showToast(String msg) {
    Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.white,
        ),
        child: Text(msg));

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 3),
    );
  }
}
