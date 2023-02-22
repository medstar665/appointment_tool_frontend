import 'package:flutter/material.dart';
import 'package:medstar_appointment/services/appointment_service.dart';
import 'package:medstar_appointment/utility/constants.dart';
import 'package:medstar_appointment/view/desktop/appointment/add.dart';
import 'package:medstar_appointment/view/desktop/appointment/edit.dart';
import 'package:medstar_appointment/view/desktop/appointment/list.dart';
import 'package:medstar_appointment/view/desktop/appointment/view.dart';
import 'package:medstar_appointment/view/desktop/components/hnavbar.dart';
import 'package:medstar_appointment/view/desktop/components/vnavbar.dart';
import 'package:provider/provider.dart';

class DesktopAppointmentPageConstants {
  static const listPage = 0;
  static const viewPage = 1;
  static const addPage = 2;
  static const editPage = 3;
}

class DesktopHomeAppointment extends StatefulWidget {
  const DesktopHomeAppointment({super.key});

  @override
  State<DesktopHomeAppointment> createState() => _DesktopHomeAppointmentState();
}

class _DesktopHomeAppointmentState extends State<DesktopHomeAppointment> {
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
    // _pageController.animateToPage(toPage,
    //     duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ChangeNotifierProvider<AppointmentService>(
      create: (context) {
        final service = AppointmentService();
        service.getAll();
        return service;
      },
      child: Scaffold(
        body: Row(
          children: [
            const DesktopVNavbar(
                currentIndex: NavbarConstants.appointmentIndex),
            Column(
              children: [
                const DesktopHNavbar(),
                Expanded(
                  child: Card(
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
                            (Constants.cardLeftMargin +
                                Constants.cardRightMargin),
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
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
