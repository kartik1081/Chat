import 'dart:async';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:textme/models/widgets/textField.dart';
import 'package:textme/models/services/fire.dart';
import 'package:textme/models/widgets/shimmer.dart';

import 'signup.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late bool _loading;
  final _form = GlobalKey<FormState>();
  Fire _fire = Fire();
  bool _withEmail = true;
  Icon _with = Icon(
    Icons.phone_android,
    color: Colors.black,
  );
  bool net = false;
  MyShimmer _shimmer = MyShimmer();
  Helper _helper = Helper();
  String sEmailPhone = '', sPassword = '', sOtp = '';
  String cCode = "+91";
  // ignore: non_constant_identifier_names
  TextEditingController email_phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController otp = TextEditingController();
  FocusNode emailPhoneNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode otpNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((event) {
      switch (event) {
        case ConnectivityResult.mobile:
          setState(() {
            net = true;
          });
          print(net);
          break;
        case ConnectivityResult.wifi:
          setState(() {
            net = true;
          });
          print(net);
          break;
        default:
          setState(() {
            net = false;
          });
          print(net);
          break;
      }
    });
    _loading = false;
  }

  @override
  void dispose() {
    super.dispose();
    email_phone.dispose();
    password.dispose();
    otpNode.dispose();
    otp.dispose();
    emailPhoneNode.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => false,
      child: Sizer(
        builder: (context, orientation, deviceType) => Scaffold(
          // backgroundColor: Color(0xFF6E00F3),
          body: _loading
              ? Center(child: _shimmer)
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
                                    color: Colors.grey[200]!.withOpacity(0.6),
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
                                        height: 40,
                                      ),
                                      Text(
                                        _withEmail
                                            ? "SignIn with Email"
                                            : "SignIn with Phone",
                                        style: TextStyle(
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[850]),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Form(
                                        key: _form,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: _withEmail
                                              ? Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    _helper.textField(
                                                        false,
                                                        TextInputType
                                                            .emailAddress,
                                                        email_phone,
                                                        emailPhoneNode,
                                                        "Enter your email",
                                                        Icon(Icons.email)),
                                                    SizedBox(
                                                      height: 10.0,
                                                    ),
                                                    _helper.textField(
                                                        true,
                                                        TextInputType
                                                            .visiblePassword,
                                                        password,
                                                        passwordNode,
                                                        "Enter your password",
                                                        Icon(Icons.lock)),
                                                  ],
                                                )
                                              : Column(
                                                  children: [
                                                    _helper.textField(
                                                      false,
                                                      TextInputType.phone,
                                                      email_phone,
                                                      emailPhoneNode,
                                                      "Enter your number",
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Icon(Icons.phone),
                                                            SizedBox(
                                                              // height: 56.0,
                                                              width: 64.0,

                                                              child:
                                                                  CountryCodePicker(
                                                                onChanged:
                                                                    (value) {
                                                                  cCode = value
                                                                      .dialCode
                                                                      .toString()
                                                                      .trim();
                                                                },
                                                                initialSelection:
                                                                    "+91",
                                                                favorite: [
                                                                  "+91",
                                                                  "IN"
                                                                ],
                                                                showFlag: false,
                                                                showDropDownButton:
                                                                    false,
                                                                showCountryOnly:
                                                                    true,
                                                                showOnlyCountryWhenClosed:
                                                                    false,
                                                                alignLeft: true,
                                                              ),
                                                            ),
                                                          ],
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
                                          onPressed: () async {
                                            if (_withEmail) {
                                              if (net) {
                                                if (email_phone
                                                        .text.isNotEmpty ||
                                                    email_phone.text.endsWith(
                                                        "@gmail.com")) {
                                                  _fire.signIn(
                                                      context,
                                                      email_phone.text.trim(),
                                                      password.text.trim());
                                                  email_phone.clear();
                                                  password.clear();
                                                  setState(() {
                                                    _loading = true;
                                                  });
                                                  Timer(Duration(seconds: 5),
                                                      () {
                                                    setState(() {
                                                      _loading = false;
                                                    });
                                                  });
                                                } else {}
                                              } else {}
                                            } else if (!_withEmail) {
                                              if (net) {
                                                if (cCode.isNotEmpty &&
                                                    email_phone
                                                        .text.isNotEmpty) {
                                                  _fire.phoneSignIn(
                                                      context,
                                                      null,
                                                      cCode.trim(),
                                                      email_phone.text.trim());
                                                } else {}
                                              } else {}
                                            }
                                          },
                                          child: Text(_withEmail
                                              ? "Sign In"
                                              : "OTP Request"),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 35.0),
                                        child: Divider(color: Colors.black),
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
                                                  email_phone.clear();
                                                  if (_withEmail) {
                                                    setState(() {
                                                      _withEmail = false;
                                                      _with = Icon(
                                                        Icons.email,
                                                        color: Colors.black,
                                                      );
                                                    });
                                                  } else if (!_withEmail) {
                                                    setState(() {
                                                      _withEmail = true;
                                                      _with = Icon(
                                                        Icons.phone_android,
                                                        color: Colors.black,
                                                      );
                                                    });
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
                                                if (net) {
                                                  _fire.googleSignIn(context);
                                                  setState(() {
                                                    _loading = true;
                                                  });
                                                  Timer(Duration(seconds: 5),
                                                      () {
                                                    setState(() {
                                                      _loading = false;
                                                    });
                                                  });
                                                } else {}
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
                      )
                      // : Center(child: Text("Network Error"))
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
                                          _withEmail
                                              ? "SignIn with Email"
                                              : "SignIn with Phone",
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
                                                _helper.textField(
                                                    false,
                                                    TextInputType.emailAddress,
                                                    email_phone,
                                                    emailPhoneNode,
                                                    "Enter your email",
                                                    Icon(Icons.email)),
                                                SizedBox(
                                                  height: 1.3.h,
                                                ),
                                                _helper.textField(
                                                    true,
                                                    TextInputType
                                                        .visiblePassword,
                                                    password,
                                                    passwordNode,
                                                    "Enter your password",
                                                    Icon(Icons.lock)),
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
                                                _fire.signIn(context,
                                                    sEmailPhone, sPassword);
                                              } else if (!_withEmail) {
                                                _fire.phoneSignIn(
                                                    context,
                                                    null,
                                                    cCode.trim(),
                                                    email_phone.text.trim());
                                              }
                                            },
                                            child: Text(_withEmail
                                                ? "Sign In"
                                                : "OTP Request"),
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
}
