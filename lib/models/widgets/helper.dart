import 'package:connectivity/connectivity.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Helper {
  FToast fToast = FToast();
  late CountryCode code;
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
        suffixIcon: obscureText
            ? IconButton(
                onPressed: () {
                  obscureText = !obscureText;
                },
                icon:
                    Icon(obscureText ? Icons.visibility : Icons.visibility_off))
            : null,
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
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 0.0000000001, color: Colors.white),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  _showToast(String msg) {
    Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.white.withOpacity(0.65),
        ),
        child: Text(msg));

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 3),
    );
  }
}
