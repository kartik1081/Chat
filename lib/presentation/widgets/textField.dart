import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textme/models/Providers/authentication_provider.dart';

class Helper {
  late CountryCode code;
  Widget textField(
    BuildContext context,
    bool obscureText,
    TextInputType textInputType,
    TextEditingController controller,
    FocusNode? focusNode,
    String hint,
    Widget? preFix,
  ) {
    return TextFormField(
      obscureText: obscureText,
      keyboardType: textInputType,
      controller: controller,
      focusNode: focusNode,
      autocorrect: true,
      onChanged: (value) {
        TextInputType.emailAddress == textInputType
            ? context.read<Authentication>().checkEmail(value)
            : null;
      },
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
}
