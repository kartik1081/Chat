import 'dart:ui';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:textme/models/widgets/helper.dart';
import 'package:textme/models/services/fire.dart';

import 'signin.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late bool _loading;
  Fire _fire = Fire();
  bool _withEmail = true;
  Icon _with = Icon(
    Icons.phone_android,
    color: Colors.black,
  );
  Helper _helper = Helper();
  String sName = '', sEmailPhone = '', sPassword = '', sOtp = '';
  String cCode = "+91";
  TextEditingController name = TextEditingController();
  // ignore: non_constant_identifier_names
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
                                          : "SignUp with Phone",
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
                                                  _helper.textField(
                                                      false,
                                                      TextInputType.name,
                                                      name,
                                                      nameNode,
                                                      true,
                                                      "Enter your name",
                                                      Icon(Icons.person)),
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  _helper.textField(
                                                      false,
                                                      TextInputType
                                                          .emailAddress,
                                                      email_phone,
                                                      emailPhoneNode,
                                                      false,
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
                                                      false,
                                                      "Enter your password",
                                                      Icon(Icons.lock)),
                                                ],
                                              )
                                            : Column(
                                                children: [
                                                  _helper.textField(
                                                      false,
                                                      TextInputType.name,
                                                      name,
                                                      nameNode,
                                                      true,
                                                      "Enter your name",
                                                      Icon(Icons.person)),
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  _helper.textField(
                                                      false,
                                                      TextInputType.phone,
                                                      email_phone,
                                                      emailPhoneNode,
                                                      false,
                                                      "Enter your number",
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 15.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Icon(Icons.phone),
                                                            SizedBox(
                                                              // height: 56.0,
                                                              width: 60.0,
                                                              child: Center(
                                                                child:
                                                                    CountryCodePicker(
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      cCode = value
                                                                          .dialCode
                                                                          .toString()
                                                                          .trim();
                                                                    });
                                                                  },
                                                                  initialSelection:
                                                                      "+91",
                                                                  favorite: [
                                                                    "+91",
                                                                    "IN"
                                                                  ],
                                                                  showFlag:
                                                                      false,
                                                                  showDropDownButton:
                                                                      false,
                                                                  showCountryOnly:
                                                                      true,
                                                                  showOnlyCountryWhenClosed:
                                                                      false,
                                                                  alignLeft:
                                                                      true,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
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
                                            _fire.phoneSignIn(
                                                context,
                                                name.text.trim(),
                                                cCode.trim(),
                                                email_phone.text.trim());
                                          }
                                        },
                                        child: Text(_withEmail
                                            ? "Sign Up"
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
                                                _withEmail
                                                    ? setState(() {
                                                        _withEmail = false;
                                                        _with = Icon(
                                                          Icons.email,
                                                          color: Colors.black,
                                                        );
                                                      })
                                                    : setState(() {
                                                        _withEmail = true;
                                                        _with = Icon(
                                                          Icons.phone_android,
                                                          color: Colors.black,
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
                                              _helper.textField(
                                                  false,
                                                  TextInputType.name,
                                                  name,
                                                  nameNode,
                                                  true,
                                                  "Enter your name",
                                                  Icon(Icons.person)),
                                              SizedBox(
                                                height: 1.3.h,
                                              ),
                                              _helper.textField(
                                                  false,
                                                  TextInputType.emailAddress,
                                                  email_phone,
                                                  emailPhoneNode,
                                                  false,
                                                  "Enter your email",
                                                  Icon(Icons.email)),
                                              SizedBox(
                                                height: 1.3.h,
                                              ),
                                              _helper.textField(
                                                  true,
                                                  TextInputType.visiblePassword,
                                                  password,
                                                  passwordNode,
                                                  false,
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
                                            if (_withEmail) {
                                              setState(() {
                                                _loading = true;
                                              });
                                              _fire.signUp(context, sName,
                                                  sEmailPhone, sPassword);
                                            } else if (!_withEmail) {
                                              _fire.phoneSignIn(
                                                  context,
                                                  name.text.trim(),
                                                  cCode.trim(),
                                                  email_phone.text.trim());
                                            }
                                          },
                                          child: Text(!_withEmail
                                              ? "OTP Request"
                                              : "Sign Up"),
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
