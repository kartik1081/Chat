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
  bool _withEmail = true;
  Icon _with = Icon(
    Icons.phone_android,
    color: Colors.black,
  );
  bool _sent = false;
  String sName = '', sEmailPhone = '', sPassword = '', sOtp = '';
  TextEditingController name = TextEditingController();
  TextEditingController email_phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController otp = TextEditingController();
  FocusNode nameNode = FocusNode();
  FocusNode emailPhoneNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode otpNode = FocusNode();

  @override
  void initState() {
    _loading = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    email_phone.dispose();
    password.dispose();
    otp.dispose();
    nameNode.dispose();
    emailPhoneNode.dispose();
    passwordNode.dispose();
    otpNode.dispose();
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
            : SizerUtil.orientation == Orientation.portrait
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
                                      height: 40,
                                    ),
                                    Text(
                                      _withEmail
                                          ? "SignUp with Email"
                                          : !_withEmail
                                              ? _sent
                                                  ? "OTP"
                                                  : "SignUp with Phone"
                                              : "",
                                      style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[850]),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Form(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: _withEmail
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  textField(
                                                      false,
                                                      TextInputType.name,
                                                      name,
                                                      nameNode,
                                                      true,
                                                      sName,
                                                      "Enter your name"),
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  textField(
                                                      false,
                                                      TextInputType
                                                          .emailAddress,
                                                      email_phone,
                                                      emailPhoneNode,
                                                      false,
                                                      sEmailPhone,
                                                      "Enter your email"),
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  textField(
                                                      true,
                                                      TextInputType
                                                          .visiblePassword,
                                                      password,
                                                      passwordNode,
                                                      false,
                                                      sPassword,
                                                      "Enter your password"),
                                                ],
                                              )
                                            : !_withEmail
                                                ? _sent
                                                    ? textField(
                                                        false,
                                                        TextInputType.number,
                                                        otp,
                                                        otpNode,
                                                        true,
                                                        sOtp,
                                                        "Enter OTP")
                                                    : Column(
                                                        children: [
                                                          textField(
                                                              false,
                                                              TextInputType
                                                                  .name,
                                                              name,
                                                              nameNode,
                                                              true,
                                                              sName,
                                                              "Enter your name"),
                                                          SizedBox(
                                                            height: 10.0,
                                                          ),
                                                          textField(
                                                              false,
                                                              TextInputType
                                                                  .number,
                                                              email_phone,
                                                              emailPhoneNode,
                                                              false,
                                                              sEmailPhone,
                                                              "Enter your number"),
                                                          SizedBox(
                                                            height: 10.0,
                                                          ),
                                                          textField(
                                                              true,
                                                              TextInputType
                                                                  .visiblePassword,
                                                              password,
                                                              passwordNode,
                                                              false,
                                                              sPassword,
                                                              "Enter your password"),
                                                        ],
                                                      )
                                                : Container(),
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
                                              _sent
                                                  ? "Resend OTP"
                                                  : "Already have account",
                                              style: TextStyle(
                                                  fontSize: 11.0.sp,
                                                  color: Colors.black),
                                            ),
                                            onPressed: () {
                                              _sent
                                                  ? null
                                                  : Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        // ignore: non_constant_identifier_names
                                                        builder:
                                                            (BuildContext) =>
                                                                SignIn(),
                                                      ),
                                                    );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 114,
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
                                          if (_withEmail) {
                                            setState(() {
                                              _loading = true;
                                            });
                                            _fire.signUp(context, sName,
                                                sEmailPhone, sPassword);
                                          } else if (!_withEmail) {
                                            if (!_sent) {
                                              setState(() {
                                                _sent = true;
                                                passwordNode.unfocus();
                                                FocusScope.of(context)
                                                    .requestFocus(otpNode);
                                              });
                                            } else if (_sent) {
                                              setState(() {
                                                _sent = false;
                                              });
                                            }
                                          }
                                        },
                                        child: Text(!_withEmail && !_sent
                                            ? "OTP Request"
                                            : "Sign Up"),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    _sent
                                        ? Container()
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 35.0),
                                            child: Divider(color: Colors.black),
                                          ),
                                    _sent
                                        ? SizedBox()
                                        : Padding(
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
                                                              .all(
                                                                  Colors.white),
                                                      elevation:
                                                          MaterialStateProperty
                                                              .all(7.0)),
                                                  onPressed: () {
                                                    setState(() {
                                                      _withEmail
                                                          ? setState(() {
                                                              _withEmail =
                                                                  false;
                                                              _with = Icon(
                                                                Icons.email,
                                                                color: Colors
                                                                    .black,
                                                              );
                                                            })
                                                          : setState(() {
                                                              _withEmail = true;
                                                              _with = Icon(
                                                                Icons
                                                                    .phone_android,
                                                                color: Colors
                                                                    .black,
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
                                                              .all(
                                                                  Colors.white),
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
                                                        MaterialStateProperty
                                                            .all(Colors.blue),
                                                    elevation:
                                                        MaterialStateProperty
                                                            .all(7.0),
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
                                                focusNode: nameNode,
                                                onFieldSubmitted: (value) {
                                                  nameNode.unfocus();
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          emailPhoneNode);
                                                },
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
                                                controller: email_phone,
                                                focusNode: emailPhoneNode,
                                                onFieldSubmitted: (value) {
                                                  emailPhoneNode.unfocus();
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          passwordNode);
                                                },
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
                                                focusNode: passwordNode,
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
                                            _fire.signUp(
                                                context,
                                                name.text,
                                                email_phone.text,
                                                password.text);
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

  Widget textField(
      bool obscureText,
      TextInputType textInputType,
      TextEditingController controller,
      FocusNode focusNode,
      bool autofocus,
      String onSave,
      String hint) {
    return TextFormField(
      obscureText: obscureText,
      keyboardType: textInputType,
      controller: controller,
      focusNode: focusNode,
      autocorrect: true,
      autofocus: autofocus,
      onSaved: (_) {
        setState(() {
          onSave = controller.text;
        });
      },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey),
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.fromLTRB(13.0, -5.0, 0.0, -5.0),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0.0000000001, color: Colors.black),
            borderRadius: BorderRadius.circular(10.0)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 0.0000000001, color: Colors.white),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
