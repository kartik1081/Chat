import 'package:flutter/material.dart';
import 'package:textme/models/widgets/searchuser.dart';

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        titleSpacing: 0,
        title: new Text("Search"),
      ),
      body: new SafeArea(child: SearchUser()),
    );
  }
}
