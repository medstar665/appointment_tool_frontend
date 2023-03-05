import 'package:flutter/material.dart';
import 'package:medstar_appointment/services/desktop_home_view_service.dart';
import 'package:medstar_appointment/utility/constants.dart';
import 'package:provider/provider.dart';

class NavbarConstants {
  static const int calenderIndex = 0;
  static const int appointmentIndex = 1;
  static const int customerIndex = 2;
  static const int serviceIndex = 3;

  static const double navbarWidth = 100;
  static const double navItemHeight = 100;
}

class DesktopVNavbar extends StatefulWidget {
  const DesktopVNavbar({super.key});

  @override
  State<DesktopVNavbar> createState() => _DesktopVNavbarState();
}

class _DesktopVNavbarState extends State<DesktopVNavbar> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: NavbarConstants.navbarWidth,
      height: size.height,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Constants.shadowColor,
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Consumer<DesktopHomeScreenService>(builder: (_, provider, __) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 100,
              // color: Constants.primaryColor,
              child: Image.asset('assets/images/brand_logo.jpg'),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: true
                  ? () {}
                  : () => provider.moveTo(NavbarConstants.calenderIndex),
              child: NavItem(
                title: 'Calender',
                icon: Icons.calendar_month_outlined,
                onPage: provider.currentIndex == NavbarConstants.calenderIndex,
              ),
            ),
            GestureDetector(
              onTap: () => provider.moveTo(NavbarConstants.appointmentIndex),
              child: NavItem(
                title: 'Appointments',
                icon: Icons.timer_outlined,
                onPage:
                    provider.currentIndex == NavbarConstants.appointmentIndex,
              ),
            ),
            GestureDetector(
              onTap: () => provider.moveTo(NavbarConstants.customerIndex),
              child: NavItem(
                title: 'Customers',
                icon: Icons.people,
                onPage: provider.currentIndex == NavbarConstants.customerIndex,
              ),
            ),
            GestureDetector(
              onTap: () => provider.moveTo(NavbarConstants.serviceIndex),
              child: NavItem(
                title: 'Services',
                icon: Icons.miscellaneous_services,
                onPage: provider.currentIndex == NavbarConstants.serviceIndex,
              ),
            ),
          ],
        );
      }),
    );
  }
}

class NavItem extends StatefulWidget {
  const NavItem(
      {super.key,
      required this.title,
      required this.icon,
      required this.onPage});
  final String title;
  final IconData icon;
  final bool onPage;

  @override
  State<NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() {
        _isHovering = true;
      }),
      onExit: (event) => setState(() {
        _isHovering = false;
      }),
      cursor: _isHovering ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: Stack(
        children: [
          if (_isHovering)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: NavbarConstants.navItemHeight,
                  width: 97,
                  color: Constants.primaryColor.withOpacity(0.35),
                ),
                Container(
                  height: NavbarConstants.navItemHeight,
                  width: 3,
                  color: Constants.primaryColor,
                ),
              ],
            ),
          if (widget.onPage)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: NavbarConstants.navItemHeight,
                  width: 97,
                  color: Constants.primaryColor.withOpacity(0.35),
                ),
                Container(
                  height: NavbarConstants.navItemHeight,
                  width: 3,
                  color: Constants.primaryColor,
                ),
              ],
            ),
          SizedBox(
            height: NavbarConstants.navItemHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  size: 35,
                  color: widget.onPage
                      ? Colors.black
                      : _isHovering
                          ? Colors.black
                          : Colors.grey.shade600,
                ),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.onPage
                        ? Colors.black
                        : _isHovering
                            ? Colors.black
                            : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
