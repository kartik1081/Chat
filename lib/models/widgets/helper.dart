import 'package:connectivity/connectivity.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Helper {
  late FToast fToast;
  late CountryCode code;

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

  Widget textField(
    bool obscureText,
    TextInputType textInputType,
    TextEditingController controller,
    FocusNode? focusNode,
    bool autofocus,
    String hint,
    Widget? preFix,
  ) {
    return TextFormField(
      obscureText: obscureText,
      keyboardType: textInputType,
      controller: controller,
      focusNode: focusNode,
      autocorrect: true,
      autofocus: autofocus,
      decoration: InputDecoration(
        prefixIcon: preFix,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey),
        fillColor: Colors.white,
        filled: true,
        isDense: true,
        contentPadding: textInputType == TextInputType.phone
            ? const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0)
            : const EdgeInsets.fromLTRB(13.0, 10.0, 0.0, 10.0),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0.0000000001, color: Colors.black),
            borderRadius: BorderRadius.circular(10.0)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 0.0000000001, color: Colors.white),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
