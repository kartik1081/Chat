import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Status extends StatelessWidget {
  Status({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      // child: StreamBuilder<dynamic>(
      //   initialData: [],
      //   stream: _firestore
      //       .collection("Users")
      //       .doc(_auth.currentUser!.uid)
      //       .collection("Favorites")
      //       .orderBy("time", descending: false)
      //       .snapshots(),
      //   builder: (context, snapshot) {
      //     return snapshot.hasData
      //         ? Container(
      //             width: MediaQuery.of(context).size.width,
      //             alignment: Alignment.topLeft,
      //             child: new ListView.builder(
      //               shrinkWrap: true,
      //               scrollDirection: Axis.horizontal,
      //               itemCount: snapshot.data.docs.length,
      //               itemBuilder: (context, index) {
      //                 return Padding(
      //                   padding: const EdgeInsets.only(left: 10.0),
      //                   child: new InkWell(
      //                     onTap: () {
      //                       Navigator.push(
      //                         context,
      //                         MaterialPageRoute(
      //                             builder: (context) => new StatusScreen(),
      //                             fullscreenDialog: true),
      //                       );
      //                     },
      //                     child: new ClipRRect(
      //                       borderRadius: BorderRadius.circular(100),
      //                       child: snapshot
      //                               .data.docs[index]["profilePic"].isNotEmpty
      //                           ? new CachedNetworkImage(
      //                               height: 70,
      //                               width: 70,
      //                               fit: BoxFit.cover,
      //                               imageUrl: snapshot.data.docs[index]
      //                                   ["profilePic"],
      //                               placeholder: (context, url) {
      //                                 return new Container(
      //                                   child: new Center(
      //                                     child:
      //                                         new CircularProgressIndicator(),
      //                                   ),
      //                                 );
      //                               },
      //                             )
      //                           : new Image(
      //                               image: AssetImage("assets/avatar.png"),
      //                               height: 70,
      //                               width: 70,
      //                             ),
      //                     ),
      //                   ),
      //                 );
      //               },
      //             ),
      //           )
      //         : new SpinKitFadingCircle(
      //             color: Color(
      //               0xFF2EF7F7,
      //             ),
      //           );
      //   },
      // ),
      height: 75,
    );
  }
}
