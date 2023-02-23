import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medstar_appointment/services/calendar_service.dart';
import 'package:medstar_appointment/utility/constants.dart';
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
    for (int i = 0; i < 24 * (60 / Constants.timeSlot) - 1; i++) {
      midNight = midNight.add(const Duration(minutes: Constants.timeSlot));
      _timeSlots.add('$i|${DateFormat.Hm().format(midNight)}');
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
          Stack(
            children: [
              const CustomDivider(),
              if (provider.isFetching)
                const LinearProgressIndicator(minHeight: 2),
            ],
          ),
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
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: DesktopCalendarConstant.timeSlotTimeWidth,
                        child: CalendarTimeWidget(timeSlots: _timeSlots),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _timeSlots.map<Widget>((curTS) {
                            return Row(
                              children: [
                                Container(
                                  width: 1,
                                  height:
                                      DesktopCalendarConstant.timeSlotHeight,
                                  color: Colors.black26,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height:
                                        DesktopCalendarConstant.timeSlotHeight,
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        const CustomDivider(
                                            color: Colors.black26),
                                        Row(
                                          children: provider.appointments
                                              .map<Widget>((appoint) {
                                            final midNight = DateTime(
                                                2023,
                                                appoint
                                                    .appointmentDateTime!.month,
                                                appoint
                                                    .appointmentDateTime!.day);
                                            final diff = appoint
                                                .appointmentDateTime!
                                                .difference(midNight);
                                            int startFrom = diff.inMinutes ~/
                                                Constants.timeSlot;
                                            int noOfSlot = (appoint.duration ??
                                                        Constants.timeSlot) ~/
                                                    Constants.timeSlot -
                                                1;
                                            final color = Constants.getHexColor(
                                                appoint.color);
                                            final curTSIndex =
                                                int.parse(curTS.split('|')[0]);
                                            if (!(startFrom <= curTSIndex &&
                                                curTSIndex <=
                                                    (startFrom + noOfSlot))) {
                                              return const SizedBox(
                                                width: 70,
                                              );
                                            }
                                            final double bottomMargin =
                                                (startFrom + noOfSlot) ==
                                                        curTSIndex
                                                    ? 1
                                                    : 0;
                                            final int textShow =
                                                startFrom + (noOfSlot ~/ 2);
                                            return Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  5, 0, 0, bottomMargin),
                                              width: 70,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1,
                                                    color: (appoint.color ==
                                                                null ||
                                                            appoint
                                                                .color!.isEmpty)
                                                        ? Colors.black45
                                                        : Colors.transparent),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(
                                                      startFrom == curTSIndex
                                                          ? 10
                                                          : 0),
                                                  topRight: Radius.circular(
                                                      startFrom == curTSIndex
                                                          ? 10
                                                          : 0),
                                                  bottomLeft: Radius.circular(
                                                      (startFrom + noOfSlot) ==
                                                              curTSIndex
                                                          ? 10
                                                          : 0),
                                                  bottomRight: Radius.circular(
                                                      (startFrom + noOfSlot) ==
                                                              curTSIndex
                                                          ? 10
                                                          : 0),
                                                ),
                                                color: color ==
                                                        Colors.transparent
                                                    ? color
                                                    : color.withOpacity(0.5),
                                              ),
                                              child: Text(textShow == curTSIndex
                                                  ? '${appoint.customer!.firstName}'
                                                  : ''),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList()
                            ..add(
                              Container(
                                width: 1,
                                height: DesktopCalendarConstant.timeSlotHeight,
                                color: Colors.black26,
                              ),
                            ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}

class CalendarTimeWidget extends StatelessWidget {
  const CalendarTimeWidget({super.key, required this.timeSlots});
  final List<String> timeSlots;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: timeSlots
          .map<Widget>((e) => Container(
                // color: Colors.green,
                height: DesktopCalendarConstant.timeSlotHeight,
                width: DesktopCalendarConstant.timeSlotTimeWidth,
                padding: const EdgeInsets.only(right: 10),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Transform.translate(
                      offset: const Offset(0, 8),
                      child: Text(e.split('|')[1]),
                    ),
                  ],
                ),
              ))
          .toList()
        ..add(
          const SizedBox(
            height: DesktopCalendarConstant.timeSlotHeight,
            width: DesktopCalendarConstant.timeSlotTimeWidth,
          ),
        ),
    );
  }
}
