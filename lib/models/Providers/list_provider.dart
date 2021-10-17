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
  List<Users> get allUsers => _usersList;
  List<Users> get chatWith => _chatWith;

  void searchUserList(String id) {
    try {
      _firestore
          .collection("Users")
          .doc(id)
          .collection("ChatWith")
          .snapshots()
          .forEach((snapshot) {
        snapshot.docs.forEach((document) {
          var user = Users.fromJson(document.data());
          _usersList.add(user);
          notifyListeners();
        });
      });
    } catch (e) {
      print("searchUserList : " + e.toString());
    }
  }
}
