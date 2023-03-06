import 'package:flutter/material.dart';

class Constants {
  // static const String baseApiUrl = 'localhost:8080';
  static const String baseApiUrl = '3.84.238.63.nip.io';

  static const MaterialColor primaryColor = Colors.blue;
  static const Color shadowColor = Color.fromARGB(255, 192, 192, 192);

  static InputDecoration disabledTextDecoration = InputDecoration(
    contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
    disabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.black38,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(15),
    ),
  );

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

  static const int timeSlot = 15; // possible values 15, 20, 30 and 60 only

  static final Map<String, String> requestHeader = {
    "Content-Type": "application/json"
  };

  static const int pageSize = 10;

  static Color getHexColor(String? color) {
    if (color == null || color.isEmpty) {
      return Colors.transparent;
    }
    color = color.toUpperCase().replaceAll('#', '');
    color = 'FF$color';
    int intColor = int.tryParse(color, radix: 16) ?? 0xFF000000;
    return Color(intColor);
  }
}
