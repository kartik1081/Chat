import 'package:flutter/material.dart';

class Favorites extends StatelessWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
      ),
      body: StreamBuilder<dynamic>(
        builder: (context, snapshot) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return Container();
            },
          );
        },
      ),
    );
  }
}
