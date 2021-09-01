import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  late String name, email, profilePic;
  Users.currentUser(DocumentSnapshot<Map<String, dynamic>> json) {
    name = json["name"];
    email = json["email"];
    profilePic = json["profilePic"];
  }
  Users();
}
