import 'package:flutter/material.dart';
import 'package:medstar_appointment/services/user_management.dart';
import 'package:medstar_appointment/utility/constants.dart';
import 'package:medstar_appointment/view/desktop/appointment/home.dart';
import 'package:medstar_appointment/view/desktop/login.dart';

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
      home: FutureBuilder(
        future: UserManagement.create(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return const SizedBox(
              height: 100,
              child: CircularProgressIndicator(
                strokeWidth: 5,
              ),
            );
          }
          return snapshot.data!.loggedIn
              ? const DesktopHomeAppointment()
              : const DesktopLogin();
        },
      ),
    );
  }
}
