import 'package:flutter/material.dart';
import 'package:medstar_appointment/view/desktop/components/vnavbar.dart';

class DesktopHNavbar extends StatelessWidget {
  const DesktopHNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: 80,
      width: size.width - NavbarConstants.navbarWidth,
      // margin: const EdgeInsets.only(top: 20),
      color: Colors.grey,
    );
  }
}
