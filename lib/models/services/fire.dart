import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:textme/models/widgets/helper.dart';
import 'package:textme/pages/homepage.dart';
import 'package:textme/pages/signin.dart';
import 'package:textme/pages/signup.dart';

class Fire {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Helper _helper = Helper();
  late String verificationId, number;

  signIn(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then(
        (value) {
          if (value.user != null) {
            _firestore
                .collection("Users")
                .doc(value.user!.uid)
                .update({"lastSignIn": DateTime.now()}).whenComplete(
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              ),
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
            "profilePic":
                "https://firebasestorage.googleapis.com/v0/b/textme-32c91.appspot.com/o/Status%2Favatar.png?alt=media&token=82fbbc78-7e2f-4f0a-9b38-d689e080913f"
          });
        }).whenComplete(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
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
          context,
          MaterialPageRoute(
            builder: (context) => SignUp(),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignUp(),
          ),
        );
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
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential).then(
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
                  "lastSignIn": DateTime.now()
                },
              ).whenComplete(() => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  ));
            } else {
              _firestore
                  .collection("Users")
                  .doc("${value.user!.uid}")
                  .update({"lastSignIn": DateTime.now()}).whenComplete(
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                ),
              );
            }
          }
        },
      );
    } catch (e) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignIn(),
        ),
      );
    }
  }

  Future phoneSignIn(
      BuildContext context, String? name, String code, String number) async {
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
                  "profilePic":
                      "https://firebasestorage.googleapis.com/v0/b/textme-32c91.appspot.com/o/Status%2Favatar.png?alt=media&token=82fbbc78-7e2f-4f0a-9b38-d689e080913f"
                },
              ).whenComplete(
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                ),
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
                  content: _helper.textField(false, TextInputType.number, _otp,
                      null, "Enter your OTP", null),
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
                                      "profilePic":
                                          "https://firebasestorage.googleapis.com/v0/b/textme-32c91.appspot.com/o/Status%2Favatar.png?alt=media&token=82fbbc78-7e2f-4f0a-9b38-d689e080913f"
                                    },
                                  ).whenComplete(
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomePage(),
                                      ),
                                    ),
                                  );
                                } else {
                                  _firestore
                                      .collection("Users")
                                      .doc(value.user!.uid)
                                      .update({
                                    "lastSignIn": DateTime.now()
                                  }).whenComplete(() => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => HomePage(),
                                            ),
                                          ));
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
  }

  Future signOut(BuildContext context) async {
    await _auth.signOut().whenComplete(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignIn(),
        ),
      );
    });
  }
}
