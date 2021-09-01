import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:textme/models/services/pageroute.dart';
import 'package:textme/presentation/pages/homepage.dart';
import 'package:textme/presentation/pages/signin.dart';

import '../users.dart';
import 'network_provider.dart';

class Authentication extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  GoogleSignInAccount? googleUser;
  late GoogleSignInAuthentication googleAuth;
  String? _token;
  late Users _currentUser;
  late Widget _startWidget;
  late String _emailValidator;
  late String _passwordValidator;
  Users get user => _currentUser;
  String? get token => _token;
  Widget get startWidet => _startWidget;
  String get emailValidator => _emailValidator;
  String get passwordValidator => _passwordValidator;

  void signUp(
      BuildContext context, String name, String email, String password) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then(
            (value) =>
                // ignore: unnecessary_null_comparison
                value != null ? _messgeToken(context, value, "signup") : null,
          );
    } on FirebaseAuthException catch (e) {
      _exception(e);
    }
    notifyListeners();
  }

  void signIn(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then(
            (value) =>
                // ignore: unnecessary_null_comparison
                value != null ? _messgeToken(context, value, "signin") : null,
          );
    } on FirebaseAuthException catch (e) {
      _exception(e);
    }
    notifyListeners();
  }

  void googleSignIn(BuildContext context) async {
    try {
      googleUser = await GoogleSignIn().signIn();
      googleAuth = await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential).then((value) =>
          value != null ? _messgeToken(context, value, "googleSignIn") : null);
    } on FirebaseAuthException catch (e) {
      _exception(e);
    }
    notifyListeners();
  }

  // ignore: unused_element
  void _messgeToken(
      BuildContext context, UserCredential credential, String store) {
    _messaging.getToken().then((value) {
      _token = value;
    }).whenComplete(
        () => _storeData(context, credential, null, null, null, store));
    notifyListeners();
  }

  void _storeData(BuildContext context, UserCredential credential, String? name,
      String? email, String? password, String store) {
    switch (store) {
      case "signup":
        _firestore.collection("Users").doc(credential.user!.uid).set({
          "id": credential.user!.uid,
          "name": name,
          "email_phone": email,
          "password": password,
          "signUpTime": DateTime.now(),
          "lastSignIn": DateTime.now(),
          "msgToken": token,
          "profilePic":
              "https://firebasestorage.googleapis.com/v0/b/textme-32c91.appspot.com/o/Status%2Favatar.png?alt=media&token=82fbbc78-7e2f-4f0a-9b38-d689e080913f"
        }).whenComplete(() => _getUser(context, credential));
        break;
      case "signin":
        _firestore.collection("Users").doc(credential.user!.uid).update({
          "lastSignIn": DateTime.now(),
          "msgToken": _token,
        }).whenComplete(() => _getUser(context, credential));
        break;
      case "googleSignIn":
        credential.additionalUserInfo!.isNewUser
            ? _firestore.collection("Users").doc(credential.user!.uid).set(
                {
                  "id": credential.user!.uid,
                  "name": googleUser!.displayName,
                  "email_phone": googleUser!.email,
                  "profilePic": googleUser!.photoUrl,
                  "signUpTime": DateTime.now(),
                  "msgToken": token,
                  "lastSignIn": DateTime.now()
                },
              )
            : _firestore.collection("Users").doc(credential.user!.uid).update({
                "lastSignIn": DateTime.now(),
                "msgToken": token,
              });
        break;
      default:
    }

    notifyListeners();
  }

  void _getUser(BuildContext context, UserCredential credential) {
    _firestore
        .collection("Users")
        .doc(credential.user!.uid)
        .get()
        .then((value) {
      _currentUser = Users.currentUser(value);
    }).whenComplete(() => _navigate(context, "home"));
    notifyListeners();
  }

  void _navigate(BuildContext context, String widget) {
    switch (widget) {
      case "signout":
        Navigator.push(
            context, SlidePageRoute(widget: SignIn(), direction: "left"));
        break;
      case "signin":
        Navigator.push(
            context, SlidePageRoute(widget: SignIn(), direction: "left"));
        break;
      default:
        Navigator.push(
            context,
            SlidePageRoute(
                widget: HomePage(
                  users: _currentUser,
                ),
                direction: "left"));
        break;
    }

    notifyListeners();
  }

  void _exception(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        print('No user found for that email.');
        break;
      case 'wrong-password':
        print('Wrong password provided for that user.');
        break;
      case 'weak-password':
        print('The password provided is too weak.');
        break;
      case 'email-already-in-use':
        print('The account already exists for that email.');
        break;
      case "network-request-failed":
        print("Check network");
        break;
      default:
        print(e.code);
        break;
    }
    notifyListeners();
  }

  void loggedInUser(BuildContext context) {
    _auth.authStateChanges().listen((event) {
      event != null
          ? _navigate(context, "homepage")
          : _navigate(context, "signin");
    });
    notifyListeners();
  }

  void signOut(BuildContext context) async {
    await _auth.signOut().whenComplete(() => _navigate(context, "signout"));
    notifyListeners();
  }

  void checkEmail(String email) {
    if (email.isEmpty || !email.endsWith("@gmail.com")) {
      _emailValidator = "Check email";
    }
    notifyListeners();
  }

  void checkPassword(String password) {
    if (password.isEmpty || password.length < 8) {
      _emailValidator = "Check Password";
    }
    notifyListeners();
  }
}
