import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:textme/models/services/pageroute.dart';
import 'package:textme/presentation/pages/homepage.dart';

class Authentication extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  late String? token;

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
}
