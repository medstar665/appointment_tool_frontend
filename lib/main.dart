import 'package:flutter/material.dart';
import 'package:medstar_appointment/services/user_management.dart';
import 'package:medstar_appointment/utility/constants.dart';
import 'package:medstar_appointment/view/desktop/desktop_home.dart';
import 'package:medstar_appointment/view/desktop/login.dart';
import 'package:provider/provider.dart';

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
        child: child!,
      ),
      home: ChangeNotifierProvider<UserManagement>(
        create: (context) => UserManagement(),
        child: _LandingPageDecider(),
      ),
    );
  }
}

class _LandingPageDecider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserManagement>(
      builder: (_, provider, __) {
        if (provider.isLoggedIn) {
          return const DesktopMainPage();
        }
        return const DesktopLogin();
      },
    );
  }
}
