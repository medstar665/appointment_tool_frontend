import 'package:flutter/material.dart';

class Constants {
  static const String baseApiUrl = 'localhost:8094';

  static const MaterialColor primaryColor = Colors.blue;
  static const Color shadowColor = Color.fromARGB(255, 192, 192, 192);

  static InputDecoration textDecoration = InputDecoration(
    contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.black54,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(15),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: primaryColor,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(15),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.red,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(15),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.red,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(15),
    ),
  );

  static const double cardLeftMargin = 25;
  static const double cardRightMargin = 20;
  static const double cardTopMargin = 20;
  static const double cardBottomMargin = 20;

  static const Map<String, String> requestHeader = {
    "Content-Type": "application/json"
  };
}
