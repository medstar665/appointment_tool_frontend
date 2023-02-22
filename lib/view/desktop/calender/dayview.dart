import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medstar_appointment/services/calendar_service.dart';
import 'package:medstar_appointment/view/desktop/calender/home.dart';
import 'package:medstar_appointment/view/desktop/components/calendar_header.dart';
import 'package:medstar_appointment/view/desktop/components/divider.dart';
import 'package:provider/provider.dart';

class DesktopDayCalendar extends StatefulWidget {
  const DesktopDayCalendar({super.key});

  @override
  State<DesktopDayCalendar> createState() => _DesktopDayCalendarState();
}

class _DesktopDayCalendarState extends State<DesktopDayCalendar> {
  final List<String> _timeSlots = [];

  @override
  void initState() {
    super.initState();
    _setTimeSlots();
  }

  void _setTimeSlots() {
    DateTime midNight = DateTime(2023);
    for (int i = 0; i < 24 * 4 - 1; i++) {
      midNight = midNight.add(const Duration(minutes: 15));
      _timeSlots.add(DateFormat.Hm().format(midNight));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarDayService>(builder: (_, provider, __) {
      return Column(
        children: [
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const DesktopCalendarHeader(viewType: CalendarView.DAY),
          ),
          const CustomDivider(),
          SizedBox(
            height: 54,
            child: Column(
              children: [
                Text(DateFormat.E().format(provider.date)),
                const SizedBox(height: 10),
                Text(
                  DateFormat.d().format(provider.date),
                  style: const TextStyle(fontSize: 18),
                ),
              ],
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
                            // Container(
                            //   height: DesktopCalendarConstant.timeSlotHeight,
                            //   color: Colors.amber,
                            // ),
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
                      // Container(
                      //   height: DesktopCalendarConstant.timeSlotHeight,
                      // ),
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
