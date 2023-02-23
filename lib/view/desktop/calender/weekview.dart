import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medstar_appointment/services/calendar_service.dart';
import 'package:medstar_appointment/utility/constants.dart';
import 'package:medstar_appointment/view/desktop/calender/home.dart';
import 'package:medstar_appointment/view/desktop/components/calendar_header.dart';
import 'package:medstar_appointment/view/desktop/components/divider.dart';
import 'package:medstar_appointment/view/desktop/components/vnavbar.dart';
import 'package:provider/provider.dart';

class DesktopWeekCalendar extends StatefulWidget {
  const DesktopWeekCalendar({super.key});

  @override
  State<DesktopWeekCalendar> createState() => _DesktopWeekCalendarState();
}

class _DesktopWeekCalendarState extends State<DesktopWeekCalendar> {
  final List<String> _timeSlots = [];

  @override
  void initState() {
    super.initState();
    _setTimeSlots();
  }

  void _setTimeSlots() {
    DateTime midNight = DateTime(2023);
    for (int i = 0; i < 24 * (60 / Constants.timeSlot) - 1; i++) {
      midNight = midNight.add(const Duration(minutes: Constants.timeSlot));
      _timeSlots.add(DateFormat.Hm().format(midNight));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double cardAvailableWidth = MediaQuery.of(context).size.width -
        NavbarConstants.navbarWidth -
        (Constants.cardLeftMargin + Constants.cardRightMargin);
    final double gridWidth =
        (cardAvailableWidth - DesktopCalendarConstant.timeSlotTimeWidth) / 7;
    return Consumer<CalendarWeekService>(builder: (_, provider, __) {
      return Column(
        children: [
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const DesktopCalendarHeader(viewType: CalendarView.WEEK),
          ),
          Stack(
            children: [
              const CustomDivider(),
              if (provider.isFetching)
                const LinearProgressIndicator(minHeight: 2),
            ],
          ),
          Container(
            height: 54,
            alignment: Alignment.centerRight,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: gridWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(DateFormat.E().format(
                          provider.firstDayOfWeek.add(Duration(days: index)))),
                      const SizedBox(height: 10),
                      Text(
                        DateFormat.d().format(
                            provider.firstDayOfWeek.add(Duration(days: index))),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 5),
          const CustomDivider(color: Colors.black26),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: _timeSlots.map<Widget>((e) {
                  return Column(
                    children: [
                      SizedBox(
                        height: DesktopCalendarConstant.timeSlotHeight,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              width: DesktopCalendarConstant.timeSlotTimeWidth,
                              padding: const EdgeInsets.only(right: 10),
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Transform.translate(
                                    offset: const Offset(0, 8),
                                    child: Text(e),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              color: Colors.black26,
                            ),
                            Row(
                              children: [0, 1, 2, 3, 4, 5, 6].map<Widget>(
                                (val) {
                                  return Row(
                                    children: [
                                      SizedBox(
                                        width: gridWidth - 1,
                                      ),
                                      if (val != 6)
                                        Container(
                                          width: 1,
                                          color: Colors.black26,
                                        ),
                                    ],
                                  );
                                },
                              ).toList(),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.black26,
                        indent: DesktopCalendarConstant.timeSlotTimeWidth,
                      ),
                    ],
                  );
                }).toList()
                  ..add(Row(
                    children: [
                      const SizedBox(
                          width: DesktopCalendarConstant.timeSlotTimeWidth),
                      Container(
                        width: 1,
                        height: DesktopCalendarConstant.timeSlotHeight,
                        color: Colors.black26,
                      ),
                      Container(
                        height: DesktopCalendarConstant.timeSlotHeight,
                      ),
                    ],
                  )),
              ),
            ),
          ),
        ],
      );
    });
  }
}
