import 'package:flutter/material.dart';
import 'package:medstar_appointment/services/calendar_service.dart';
import 'package:medstar_appointment/utility/constants.dart';
import 'package:medstar_appointment/view/desktop/calender/dayview.dart';
import 'package:medstar_appointment/view/desktop/calender/weekview.dart';
import 'package:medstar_appointment/view/desktop/components/hnavbar.dart';
import 'package:medstar_appointment/view/desktop/components/vnavbar.dart';
import 'package:provider/provider.dart';

class DesktopCalendarConstant {
  static const int dayView = 0;
  static const int weekView = 1;
  static const double timeSlotTimeWidth = 80;
  static const double timeSlotHeight = 60;
}

class DesktopHomeCalendar extends StatefulWidget {
  const DesktopHomeCalendar({super.key});

  @override
  State<DesktopHomeCalendar> createState() => _DesktopHomeCalendarState();
}

class _DesktopHomeCalendarState extends State<DesktopHomeCalendar> {
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CalendarDayService>(
            create: (context) => CalendarDayService()),
        ChangeNotifierProvider<CalendarWeekService>(
            create: (context) => CalendarWeekService()),
        ChangeNotifierProvider<CalendarViewService>(
            create: (context) => CalendarViewService()),
      ],
      child: Scaffold(
        body: Row(
          children: [
            const DesktopVNavbar(currentIndex: NavbarConstants.calenderIndex),
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
                      child: Consumer<CalendarViewService>(
                          builder: (_, provider, __) {
                        return SizedBox(
                          width: size.width -
                              (NavbarConstants.navbarWidth) -
                              (Constants.cardLeftMargin +
                                  Constants.cardRightMargin),
                          child: provider.isDayView
                              ? const DesktopDayCalendar()
                              : const DesktopWeekCalendar(),
                        );
                      }),
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
