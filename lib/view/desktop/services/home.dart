import 'package:flutter/material.dart';
import 'package:medstar_appointment/services/services_service.dart';
import 'package:medstar_appointment/utility/constants.dart';
import 'package:medstar_appointment/view/desktop/components/hnavbar.dart';
import 'package:medstar_appointment/view/desktop/components/vnavbar.dart';
import 'package:medstar_appointment/view/desktop/services/add.dart';
import 'package:medstar_appointment/view/desktop/services/edit.dart';
import 'package:medstar_appointment/view/desktop/services/list.dart';
import 'package:medstar_appointment/view/desktop/services/view.dart';
import 'package:provider/provider.dart';

class DesktopServicePageConstants {
  static const int listPage = 0;
  static const int viewPage = 1;
  static const int addPage = 2;
  static const int editPage = 3;
}

class DesktopHomeService extends StatefulWidget {
  const DesktopHomeService({super.key});

  @override
  State<DesktopHomeService> createState() => _DesktopHomeServiceState();
}

class _DesktopHomeServiceState extends State<DesktopHomeService> {
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
    //     duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ChangeNotifierProvider<ServiceService>(
      create: (context) {
        final service = ServiceService();
        service.getAll();
        return service;
      },
      child: Scaffold(
        body: Row(
          children: [
            const DesktopVNavbar(currentIndex: NavbarConstants.serviceIndex),
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
                    child: SizedBox(
                      width: size.width -
                          (NavbarConstants.navbarWidth) -
                          (Constants.cardLeftMargin +
                              Constants.cardRightMargin),
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          DesktopListServices(goToPage: goToPage),
                          DesktopViewService(goToPage: goToPage),
                          DesktopAddService(goToPage: goToPage),
                          DesktopEditService(goToPage: goToPage),
                        ],
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
