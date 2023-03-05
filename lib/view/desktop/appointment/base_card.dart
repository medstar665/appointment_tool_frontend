import 'package:flutter/material.dart';
import 'package:medstar_appointment/utility/constants.dart';
import 'package:medstar_appointment/view/desktop/appointment/add.dart';
import 'package:medstar_appointment/view/desktop/appointment/edit.dart';
import 'package:medstar_appointment/view/desktop/appointment/list.dart';
import 'package:medstar_appointment/view/desktop/appointment/view.dart';
import 'package:medstar_appointment/view/desktop/components/vnavbar.dart';

class DesktopAppointmentPageConstants {
  static const listPage = 0;
  static const viewPage = 1;
  static const addPage = 2;
  static const editPage = 3;
}

class DesktopAppointmentCard extends StatefulWidget {
  const DesktopAppointmentCard({super.key});

  @override
  State<DesktopAppointmentCard> createState() => _DesktopAppointmentCardState();
}

class _DesktopAppointmentCardState extends State<DesktopAppointmentCard> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void goToPage(int toPage) {
    _pageController.jumpToPage(toPage);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      margin: const EdgeInsets.fromLTRB(
        Constants.cardLeftMargin,
        Constants.cardTopMargin,
        Constants.cardRightMargin,
        Constants.cardBottomMargin,
      ),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: size.width -
              (NavbarConstants.navbarWidth) -
              (Constants.cardLeftMargin + Constants.cardRightMargin),
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              DesktopListApointment(goToPage: goToPage),
              DesktopViewAppointment(goToPage: goToPage),
              DesktopAddAppointment(goToPage: goToPage),
              DesktopEditAppointment(goToPage: goToPage),
            ],
          ),
        ),
      ),
    );
  }
}
