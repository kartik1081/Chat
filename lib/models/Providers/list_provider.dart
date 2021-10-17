import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:textme/models/Providers/authentication_provider.dart';
import 'package:textme/models/services/fire.dart';
import 'package:textme/models/users.dart';

class ListProvider extends ChangeNotifier {
  Authentication _authentication = Authentication();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Users> _allUsers = [];
  List<Users> _chatWith = [];
  List<Users> get allUsers => _allUsers;
  List<Users> get chatWith => _chatWith;

  // Future<void> userList(BuildContext context) async {
  //   _firestore
  //       .collection("Users")
  //       .where("id", isNotEqualTo: context.watch<Authentication>().user.id)
  //       .snapshots()
  //       .listen((event) {
  //     for (var i in event.docs) {
  //       _allUsers.add(Users.currentUser(i));
  //     }
  //     print(_allUsers);
  //   });
  //   notifyListeners();
  // }
  // searchUserList(BuildContext context) {
  //   final _authentication = Provider.of<Authentication>(context, listen: false);
  //   List<Users> _list = [];
  //   _firestore
  //       .collection("Users")
  //       .doc(_authentication.user.id)
  //       .collection("ChatWith")
  //       .snapshots()
  //       .forEach((snapshot) {
  //     snapshot.docs.forEach((document) {
  //       _list.add(Users.fromJson(document.data()));
  //       notifyListeners();
  //     });
  //   });

  //   _chatWith = _list;
  //   print("ChatWith List" + _chatWith.toString());
  // }
}
