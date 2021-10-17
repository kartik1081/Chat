import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  late String name, email, profilePic, id, lastSignIn;
  late bool favorite;
  Users(
      {required this.name,
      required this.email,
      required this.id,
      required this.lastSignIn,
      required this.profilePic});

  Map<String, dynamic> createMap() {
    return {
      'name': name,
      'email_phone': email,
      'profilePic': profilePic,
      'id': id,
      'favorite': favorite
    };
  }

  Users.chatWith(Map<String, dynamic> json)
      : name = json["name"],
        email = json["email_phone"],
        profilePic = json["profilePic"],
        id = json["id"],
        favorite = json["favorite"];

  Users.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email_phone'],
        profilePic = json["profilePic"],
        id = json["id"];
}
