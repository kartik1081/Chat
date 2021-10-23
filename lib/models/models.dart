import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  late String name, email, profilePic, id;
  late bool favorite;
  late Timestamp time;
  Users(
      {required this.name,
      required this.email,
      required this.id,
      // required this.lastSignIn,
      required this.profilePic});

  Users.chatWith(Map<String, dynamic> json)
      : name = json["name"],
        time = json["time"],
        profilePic = json["profilePic"],
        id = json["id"],
        favorite = json["favorite"];

  Users.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email_phone'],
        profilePic = json["profilePic"],
        id = json["id"];
}

class Message {
  late String msg;
  late Timestamp time;
  Message.forG(Map<String, dynamic> json)
      : msg = json["msg"],
        time = json["time"];
  Message.forP(Map<String, dynamic> json)
      : msg = json["msg"],
        time = json["time"];
}
