import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:textme/models/Providers/authentication_provider.dart';
import 'package:textme/models/services/fire.dart';
import 'package:textme/models/users.dart';

class ListProvider extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Users> _usersList = [];
  List<Users> _chatWith = [];
  List<Users> get userList => _usersList;
  List<Users> get chatWith => _chatWith;

  // void setUsers(Users document) {
  //   _usersList.add(document);
  //   notifyListeners();
  // }

  Stream<Users> searchUserList(String id) async* {
    // Users users;
    _firestore
        .collection("Users")
        .doc(id)
        .collection("ChatWith")
        .snapshots()
        .forEach((snapshot) {
      snapshot.docs.forEach((document) async* {
        _usersList.add(Users.fromJson(document.data()));
        notifyListeners();
      });
    }).onError((error, _) => print(error.toString()));
  }
}
