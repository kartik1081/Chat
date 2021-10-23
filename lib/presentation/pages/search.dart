import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:textme/models/Providers/authentication_provider.dart';
import 'package:textme/models/Providers/list_provider.dart';
import 'package:textme/models/services/fire.dart';
import 'package:textme/models/services/pageroute.dart';
import 'package:textme/models/models.dart';
import 'package:uuid/uuid.dart';

import 'chatdetail.dart';
import 'createroom.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with SingleTickerProviderStateMixin {
  TextEditingController search = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Fire _fire = Fire();
  bool _isSearching = false;
  late var uuid;

  @override
  void initState() {
    super.initState();
    setState(() {
      uuid = Uuid().v1();
    });
  }

  @override
  Widget build(BuildContext context) {
    // var list = Provider.of<List<Users>>(context);
    // print(list[2].name.toString());
    List<Users> _list = Provider.of<List<Users>>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _isSearching
            ? TextFormField(
                onChanged: (value) {
                  setState(() {});
                },
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Type your messege!";
                  }
                },
                controller: search,
                cursorHeight: 22.0,
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding:
                      const EdgeInsets.fromLTRB(13.0, -5.0, 0.0, -5.0),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 0.0000000001, color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0)),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 0.0000000001, color: Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              )
            : Text("Search"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (_isSearching) {
                  search.clear();
                }
              });
            },
            icon: Icon(Icons.search),
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  uuid = Uuid().v4();
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateRoom(uuid: uuid.toString()),
                      fullscreenDialog: true),
                );
              },
              child: Text("Room")),
        ],
      ),
      body: SafeArea(
        child: _isSearching
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: StreamBuilder<dynamic>(
                  stream: _firestore
                      .collection("Users")
                      .where("name", isEqualTo: search.text)
                      // .orderBy("time", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              return StreamBuilder<dynamic>(
                                  stream: _firestore
                                      .collection("Users")
                                      .doc(_auth.currentUser!.uid)
                                      .collection("ChatWith")
                                      .doc(snapshot.data.docs[index]["id"])
                                      .snapshots(),
                                  builder: (context, snapshots) {
                                    if (snapshots.hasData) {
                                      Map<String, dynamic>? data =
                                          snapshots.data.data();
                                      return data != null
                                          ? ListItem(
                                              name: snapshot.data.docs[index]
                                                  ["name"],
                                              id: snapshot.data.docs[index]
                                                  ["id"],
                                              profilePic: snapshot.data
                                                  .docs[index]["profilePic"],
                                              added: true,
                                              add_remove: "Remove",
                                            )
                                          : ListItem(
                                              name: snapshot.data.docs[index]
                                                  ["name"],
                                              id: snapshot.data.docs[index]
                                                  ["id"],
                                              profilePic: snapshot.data
                                                  .docs[index]["profilePic"],
                                              added: false,
                                              add_remove: "Add",
                                            );
                                    } else {
                                      return SpinKitFadingCircle(
                                          color: Color(0xFF2EF7F7));
                                    }
                                  });
                            },
                          )
                        : SpinKitFadingCircle(
                            color: Color(0xFF2EF7F7),
                          );
                  },
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: _list != null
                    ? ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: _list.length,
                        itemBuilder: (context, index) {
                          return StreamBuilder<dynamic>(
                              stream: _firestore
                                  .collection("Users")
                                  .doc(_auth.currentUser!.uid)
                                  .collection("ChatWith")
                                  .doc(_list[index].id)
                                  .snapshots(),
                              builder: (context, snapshots) {
                                if (snapshots.hasData) {
                                  Map<String, dynamic>? data =
                                      snapshots.data.data();
                                  return _list[index].id != null
                                      ? ListItem(
                                          name: _list[index].name,
                                          id: _list[index].id,
                                          profilePic: _list[index].profilePic,
                                          added: true,
                                          add_remove: "Remove",
                                        )
                                      : ListItem(
                                          name: _list[index].name,
                                          id: _list[index].id,
                                          profilePic: _list[index].profilePic,
                                          added: false,
                                          add_remove: "Add",
                                        );
                                } else {
                                  return Shimmer.fromColors(
                                    baseColor: Color(0xFF31444B),
                                    highlightColor: Color(0xFF618A99),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 4.0,
                                        horizontal: 8.0,
                                      ),
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Color(0xFF31444B),
                                      ),
                                    ),
                                  );
                                }
                              });
                        },
                      )
                    : SpinKitFadingCircle(
                        color: Color(0xFF2EF7F7),
                      )),
      ),
    );
  }
}

// showToast(BuildContext context, String add_remove) {
//   Fluttertoast.showToast(
//       msg: add_remove,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.grey,
//       textColor: Colors.white.withOpacity(0.5),
//       fontSize: 16.0);
// }

// ignore: must_be_immutable
class ListItem extends StatefulWidget {
  ListItem(
      {Key? key,
      required this.name,
      required this.id,
      required this.profilePic,
      // ignore: non_constant_identifier_names
      required this.add_remove,
      required this.added})
      : super(key: key);
  // ignore: non_constant_identifier_names
  late String name, id, profilePic, add_remove;
  late bool added;

  @override
  _ListItemState createState() =>
      _ListItemState(added: added, add_remove: add_remove);
}

class _ListItemState extends State<ListItem>
    with SingleTickerProviderStateMixin {
  // ignore: non_constant_identifier_names
  _ListItemState({required this.added, required this.add_remove});
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late AnimationController _controller;
  late Animation _animation0;
  late Animation _animation1;
  bool added;
  // ignore: non_constant_identifier_names
  String add_remove;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 50),
    );
    _animation0 =
        ColorTween(begin: Colors.green, end: Colors.red).animate(_controller);
    _animation1 = ColorTween(
      begin: Colors.green.withOpacity(0.1),
      end: Colors.red.withOpacity(0.1),
    ).animate(_controller);

    setState(() {
      if (added == true) {
        _controller.forward();
      }
      if (added == false) {
        _controller.reverse();
      }
    });
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          add_remove = "Remove";
          // showToast(context, "Added");
        });
      }
      if (status == AnimationStatus.dismissed) {
        setState(() {
          add_remove = "Add";
          // showToast(context, "Removed");
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            ScalePageRoute(
                widget: ChatDetail(
                  name: widget.name,
                  userId: widget.id,
                  group: false,
                  profilePic: widget.profilePic,
                ),
                out: false));
      },
      child: Container(
        height: widget.id != _auth.currentUser!.uid ? 75.0 : 0.0,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: widget.profilePic.isNotEmpty
                        ? CachedNetworkImage(
                            height: 49,
                            width: 49,
                            fit: BoxFit.cover,
                            imageUrl: widget.profilePic,
                            placeholder: (context, url) {
                              return Container(
                                height: 100,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                          )
                        : Image(
                            image: AssetImage("assets/avatar.png"),
                            height: 49,
                            width: 49,
                          ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Text(
                      widget.name,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w800),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (added) {
                        await _firestore
                            .collection("Users")
                            .doc(_auth.currentUser!.uid)
                            .collection("ChatWith")
                            .doc(widget.id)
                            .delete();
                      } else if (!added) {
                        await _firestore
                            .collection("Users")
                            .doc(_auth.currentUser!.uid)
                            .collection("ChatWith")
                            .doc(widget.id)
                            .set({
                          "name": widget.name,
                          "profilePic": widget.profilePic,
                          "time": DateTime.now(),
                          "id": widget.id,
                          "favorite": false
                        });
                      }

                      setState(() {
                        added ? _controller.reverse() : _controller.forward();
                        added = !added;
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(color: _animation1.value),
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) => Center(
                            child: Text(
                              add_remove,
                              style: TextStyle(
                                  color: _animation0.value,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Divider()
            ],
          ),
        ),
      ),
    );
  }
}
