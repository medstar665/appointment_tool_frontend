import 'package:flutter/material.dart';
import 'package:medstar_appointment/utility/constants.dart';
import 'package:medstar_appointment/view/desktop/components/vnavbar.dart';
import 'package:medstar_appointment/view/desktop/customer/add.dart';
import 'package:medstar_appointment/view/desktop/customer/edit.dart';
import 'package:medstar_appointment/view/desktop/customer/list.dart';
import 'package:medstar_appointment/view/desktop/customer/view.dart';

class DesktopCustomerPageConstants {
  static const listPage = 0;
  static const viewPage = 1;
  static const addPage = 2;
  static const editPage = 3;
}

class DesktopCustomerCard extends StatefulWidget {
  const DesktopCustomerCard({super.key});

  @override
  State<DesktopCustomerCard> createState() => _DesktopCustomerCardState();
}

class _DesktopCustomerCardState extends State<DesktopCustomerCard> {
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
              DesktopListCustomer(goToPage: goToPage),
              DesktopViewCustomer(goToPage: goToPage),
              DesktopAddCustomer(goToPage: goToPage),
              DesktopEditCustomer(goToPage: goToPage),
            ],
          ),
        ),
      ),
    );
  }
}
