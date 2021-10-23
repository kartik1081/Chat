import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:textme/models/services/pageroute.dart';
import 'package:textme/presentation/pages/homepage.dart';
import 'package:textme/presentation/pages/signin.dart';

import '../models.dart';

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
  late bool _loggedIn;
  late bool _isNet;
  Users get user => _currentUser;
  String? get token => _token;
  Widget get startWidet => _startWidget;
  String get emailValidator => _emailValidator;
  String get passwordValidator => _passwordValidator;
  bool get loggedIn => _loggedIn;
  bool get isNet => _isNet;

  Future<void> signUp(
      BuildContext context, String name, String email, String password) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        // ignore: unnecessary_null_comparison
        if (value != null) {
          _loggedIn = true;
          _messgeToken(context, value, "signup");
        } else {
          return null;
        }
      });
    } on FirebaseAuthException catch (e) {
      _exception(e);
    }
  }

  Future<void> signIn(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      if (email.isNotEmpty || email.endsWith("@gmail.com")) {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) {
          // ignore: unnecessary_null_comparison
          if (value != null) {
            _loggedIn = true;
            _messgeToken(context, value, "signin");
          } else {
            return null;
          }
        });
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      _exception(e);
    }
    print("signIn");
  }

  Future<void> googleSignIn(BuildContext context) async {
    try {
      googleUser = await GoogleSignIn().signIn();
      googleAuth = await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential).then((value) {
        // ignore: unnecessary_null_comparison
        if (value != null) {
          _loggedIn = true;
          _messgeToken(context, value, "googleSignIn");
        } else {
          return null;
        }
      });
    } on FirebaseAuthException catch (e) {
      _exception(e);
    }
  }

  // ignore: unused_element
  void _messgeToken(
      BuildContext context, UserCredential credential, String store) {
    _messaging.onTokenRefresh.listen((value) {
      _token = value;
      _storeData(context, credential, null, null, null, store);
    });
    print("messageToken");
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
        }).whenComplete(() => _getUser(context, credential, null));
        break;
      case "signin":
        _firestore.collection("Users").doc(credential.user!.uid).update({
          "lastSignIn": DateTime.now(),
          "msgToken": _token,
        }).whenComplete(() => _getUser(context, credential, null));
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
    print("storeData");
  }

  Future<void> _getUser(
      BuildContext context, UserCredential? credential, User? users) async {
    credential != null
        ? _firestore
            .collection("Users")
            .doc(credential.user!.uid)
            .get()
            .then((value) {
            Map<String, dynamic>? map = value.data();
            _currentUser = Users.fromJson(map!);
          }).whenComplete(() => _navigate(context, "home"))
        : _firestore.collection("Users").doc(users!.uid).get().then((value) {
            Map<String, dynamic>? map = value.data();
            _currentUser = Users.fromJson(map!);
          }).whenComplete(() => _navigate(context, "home"));
    print("getUser");
  }

  void _navigate(BuildContext context, String widget) {
    switch (widget) {
      case "signin":
        Navigator.push(
            context, SlidePageRoute(widget: SignIn(), direction: "left"));
        break;
      case "home":
        Navigator.push(
            context, SlidePageRoute(widget: HomePage(), direction: "right"));
        break;
      default:
    }
    print("navigator");
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
    print("exception");
    notifyListeners();
  }

  void loggedInUser(BuildContext context) {
    try {
      _auth.authStateChanges().listen((event) {
        print(event);
        if (event != null) {
          _loggedIn = true;
          _getUser(context, null, event);
        } else {
          _loggedIn = false;
          _navigate(context, "signin");
        }
      });
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  void signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  void checkEmail(String email) {
    if (email.isEmpty || !email.endsWith("@gmail.com")) {
      _emailValidator = "Check email";
    } else {
      _emailValidator = '';
    }
  }

  void checkPassword(String password) {
    if (password.isEmpty || password.length < 8) {
      _passwordValidator = "Check Password";
    } else {
      _passwordValidator = '';
    }
  }

  void checkNetwork() {
    Connectivity().onConnectivityChanged.listen((event) {
      switch (event) {
        case ConnectivityResult.mobile:
          _isNet = true;
          break;
        case ConnectivityResult.wifi:
          _isNet = true;
          break;
        default:
          _isNet = false;
          break;
      }
      print(_isNet);
    });
    notifyListeners();
  }
}
