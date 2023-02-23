import 'package:flutter/material.dart';
import 'package:medstar_appointment/utility/constants.dart';
import 'package:medstar_appointment/view/desktop/calender/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medstar Appointment Tool',
      theme: ThemeData(
        primarySwatch: Constants.primaryColor,
        fontFamily: 'OpenSans',
      ),
      debugShowCheckedModeBanner: false,
      builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!),
      home: const DesktopHomeCalendar(),
    );
  }
}
