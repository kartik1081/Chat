import 'package:flutter/material.dart';

class CustomLocalizations {
  CustomLocalizations(this.locale);
  final Locale locale;

  static CustomLocalizations? of(BuildContext context) {
    return Localizations.of<CustomLocalizations>(context, CustomLocalizations);
  }
}
