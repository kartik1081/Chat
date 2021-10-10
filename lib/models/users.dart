import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  late String name, email, profilePic, id, lastSignIn;
  Users.currentUser(DocumentSnapshot json) {
    name = json["name"];
    email = json["email_phone"];
    profilePic = json["profilePic"];
    id = json["id"];
  }
}
