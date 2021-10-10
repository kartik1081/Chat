import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/src/provider.dart';
import 'package:textme/models/Providers/authentication_provider.dart';

class ListProvider extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Widget _searchList;
  Widget get searchList => _searchList;

  Future<void> getSearchList(BuildContext context) async {
    StreamBuilder<dynamic>(
        stream: _firestore
            .collection("Users")
            .where("id", isNotEqualTo: context.watch<Authentication>().user.id)
            .snapshots(),
        builder: (context, snapshot) {
          return _searchList;
        });
  }
}
