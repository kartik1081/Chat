import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:textme/pages/homepage.dart';
import 'package:textme/pages/signin.dart';
import 'package:textme/pages/signup.dart';

class Fire {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future signIn(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        _firestore
            .collection("Users")
            .doc(value.user!.uid)
            .update({"lastSignIn": DateTime.now()});
      }).whenComplete(
        () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
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
            "email": email,
            "password": password,
            "lastSignIn": DateTime.now(),
            "profilePic": ""
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
          _firestore.collection("Users").doc("${value.user!.uid}").set(
            {
              "id": value.user!.uid,
              "name": googleUser.displayName,
              "email": googleUser.email,
              "profilePic": googleUser.photoUrl,
              "lastSignIn": DateTime.now()
            },
          );
        },
      ).whenComplete(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future phoneSignIn(BuildContext context, String number) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth
            .signInWithCredential(credential)
            .then(
              (value) =>
                  _firestore.collection("Users").doc(value.user!.uid).set(
                {
                  "id": value.user!.uid,
                  "phoneNumber": number,
                  "lastSignIn": DateTime.now(),
                  "profilePic": ""
                },
              ),
            )
            .whenComplete(
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              ),
            );
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        String smsCode = 'xxxx';

        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);
        _auth
            .signInWithCredential(credential)
            .then(
              (value) =>
                  _firestore.collection("Users").doc(value.user!.uid).set(
                {
                  "id": value.user!.uid,
                  "phoneNumber": number,
                  "lastSignIn": DateTime.now(),
                  "profilePic": ""
                },
              ),
            )
            .whenComplete(
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              ),
            );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
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
