import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/src/provider.dart';
import 'package:textme/models/Providers/authentication_provider.dart';
import 'package:textme/models/services/pageroute.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:textme/models/users.dart';
import 'package:textme/presentation/pages/homepage.dart';
import 'package:textme/presentation/pages/signin.dart';
import 'package:textme/presentation/widgets/textField.dart';

class Fire {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  Helper _helper = Helper();
  late String? token;
  late String verificationId, number;

  signIn(
    BuildContext context,
    String email,
    String password,
  ) async {
    _messaging.getToken().then((value) {
      token = value;
    });
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then(
        (value) {
          if (value.user != null) {
            _firestore.collection("Users").doc(value.user!.uid).update({
              "lastSignIn": DateTime.now(),
              "msgToken": token,
            }).whenComplete(
              () => Navigator.push(context,
                  SlidePageRoute(widget: HomePage(), direction: "right")),
            );
          }
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future signUp(
      BuildContext context, String name, String email, String password) async {
    try {
      _messaging.getToken().then((value) {
        token = value;
      });
      if (email.endsWith("@gmail.com")) {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) {
          _firestore.collection("Users").doc(value.user!.uid).set({
            "id": value.user!.uid,
            "name": name,
            "email_phone": email,
            "password": password,
            "signUpTime": DateTime.now(),
            "lastSignIn": DateTime.now(),
            "msgToken": token,
            "profilePic":
                "https://firebasestorage.googleapis.com/v0/b/textme-32c91.appspot.com/o/Status%2Favatar.png?alt=media&token=82fbbc78-7e2f-4f0a-9b38-d689e080913f"
          });
        }).whenComplete(() {
          Navigator.push(
              context, SlidePageRoute(widget: HomePage(), direction: "right"));
        });
      } else {
        name = '';
        email = '';
        password = '';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        Navigator.push(
            context, SlidePageRoute(widget: HomePage(), direction: "left"));
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        Navigator.push(
            context, SlidePageRoute(widget: HomePage(), direction: "left"));
      }
    } catch (e) {
      print(e.toString());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("User Already Exist!"),
            );
          });
      Navigator.pop(context);
    }
  }

  Future googleSignIn(BuildContext context) async {
    try {
      _messaging.getToken().then((value) {
        token = value;
      });
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential).then(
        (value) {
          if (value.user != null) {
            if (value.additionalUserInfo!.isNewUser) {
              _firestore.collection("Users").doc("${value.user!.uid}").set(
                {
                  "id": value.user!.uid,
                  "name": googleUser.displayName,
                  "email_phone": googleUser.email,
                  "profilePic": googleUser.photoUrl,
                  "signUpTime": DateTime.now(),
                  "msgToken": token,
                  "lastSignIn": DateTime.now()
                },
              ).whenComplete(() => Navigator.push(context,
                  SlidePageRoute(widget: HomePage(), direction: "right")));
            } else {
              _firestore.collection("Users").doc("${value.user!.uid}").update({
                "lastSignIn": DateTime.now(),
                "msgToken": token,
              }).whenComplete(
                () => Navigator.push(context,
                    SlidePageRoute(widget: HomePage(), direction: "right")),
              );
            }
          }
        },
      );
    } catch (e) {
      Navigator.push(
          context, SlidePageRoute(widget: SignIn(), direction: "right"));
    }
  }

  Future phoneSignIn(
      BuildContext context, String? name, String code, String number) async {
    try {
      _messaging.getToken().then((value) {
        token = value;
      });
      TextEditingController _otp = TextEditingController();
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: code + number,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            Navigator.pop(context);
            await _auth.signInWithCredential(credential).then((value) {
              if (value.user != null) {
                _firestore.collection("Users").doc(value.user!.uid).set(
                  {
                    "id": value.user!.uid,
                    "name": name,
                    "email_phone": number,
                    "lastSignIn": DateTime.now(),
                    "msgToken": token,
                    "profilePic":
                        "https://firebasestorage.googleapis.com/v0/b/textme-32c91.appspot.com/o/Status%2Favatar.png?alt=media&token=82fbbc78-7e2f-4f0a-9b38-d689e080913f"
                  },
                ).whenComplete(
                  () => Navigator.push(context,
                      SlidePageRoute(widget: HomePage(), direction: "right")),
                );
              }
            });
          } catch (e) {
            print("varificationCompleted");
            print(e.toString());
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
          print("VarificationFailed");
          print(e.toString());
        },
        codeSent: (String verificationId, int? resendToken) async {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    content: _helper.textField(
                        context,
                        false,
                        TextInputType.number,
                        _otp,
                        null,
                        "Enter your OTP",
                        null),
                    title: Text("OTP"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("cancle")),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            try {
                              AuthCredential credential =
                                  PhoneAuthProvider.credential(
                                      verificationId: verificationId,
                                      smsCode: _otp.text.trim());
                              _auth
                                  .signInWithCredential(credential)
                                  .then((value) {
                                if (value.user != null) {
                                  if (value.additionalUserInfo!.isNewUser) {
                                    _firestore
                                        .collection("Users")
                                        .doc(value.user!.uid)
                                        .set(
                                      {
                                        "id": value.user!.uid,
                                        "name": name,
                                        "email_phone": number,
                                        "signUpTime": DateTime.now(),
                                        "lastSignIn": DateTime.now(),
                                        "msgToken": token,
                                        "profilePic":
                                            "https://firebasestorage.googleapis.com/v0/b/textme-32c91.appspot.com/o/Status%2Favatar.png?alt=media&token=82fbbc78-7e2f-4f0a-9b38-d689e080913f"
                                      },
                                    ).whenComplete(
                                      () => Navigator.push(
                                          context,
                                          SlidePageRoute(
                                              widget: HomePage(),
                                              direction: "right")),
                                    );
                                  } else {
                                    _firestore
                                        .collection("Users")
                                        .doc(value.user!.uid)
                                        .update({
                                      "lastSignIn": DateTime.now(),
                                      "msgToken": token,
                                    }).whenComplete(() => Navigator.push(
                                            context,
                                            SlidePageRoute(
                                                widget: HomePage(),
                                                direction: "right")));
                                  }
                                }
                              });
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Text("Sign In"))
                    ],
                  ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut(BuildContext context) async {
    await _auth.signOut().whenComplete(() {
      Navigator.push(
          context, SlidePageRoute(widget: SignIn(), direction: "left"));
    });
  }

  Stream<List<Users>> searchUserList(String id) {
    try {
      return _firestore
          .collection("Users")
          .doc(id)
          .collection("ChatWith")
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((document) => Users.chatWith(document.data()))
              .toList());
    } catch (e) {
      print("searchUserList : " + e.toString());
      return [] as Stream<List<Users>>;
    }
  }

  Stream<List<Users>> chatWithUserList(String id) {
    try {
      return _firestore
          .collection("Users")
          .doc(id)
          .collection("ChatWith")
          .orderBy("time", descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((document) => Users.chatWith(document.data()))
              .toList());
    } catch (e) {
      print("searchUserList : " + e.toString());
      return [] as Stream<List<Users>>;
    }
  }
}
