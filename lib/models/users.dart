import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Users {
  late String? name, email, profilePic;
  Users.currentUser(DocumentSnapshot<Map<String, dynamic>> json) {
    name = json["name"];
    email = json["email"];
    profilePic = json["profilePic"];
  }
  Users.user(User? json) {
    name = json!.displayName;
    email = json.email;
    profilePic = json.photoURL;
  }
  Users();
}
