import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Helper {
  late FToast fToast;

  Future<bool> isAvailable() async {
    var isNetAvail = await (Connectivity().checkConnectivity());
    if (isNetAvail == ConnectivityResult.wifi) {
      return true;
    } else if (isNetAvail == ConnectivityResult.mobile) {
      return true;
    }
    return false;
  }

  Future<void> showToast(BuildContext context, String msg, String name) async {
    Widget toast = Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.grey.withOpacity(0.5),
        ),
        child: name == " "
            ? Text(msg)
            : Text(
                name + " " + msg,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
      ),
    );

    fToast.showToast(
      child: toast,
      toastDuration: Duration(seconds: 2),
      positionedToastBuilder: (context, child) {
        return Positioned(
          child: child,
          top: MediaQuery.of(context).size.height * 0.8,
          left: 0.0,
        );
      },
    );
  }
}
