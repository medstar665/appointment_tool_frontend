import 'package:flutter/material.dart';
import 'package:medstar_appointment/services/calendar_service.dart';
import 'package:medstar_appointment/utility/constants.dart';
import 'package:provider/provider.dart';

class DesktopCalendarHeader extends StatefulWidget {
  const DesktopCalendarHeader({super.key, required this.viewType});
  final CalendarView viewType;

  @override
  State<DesktopCalendarHeader> createState() => _DesktopCalendarHeaderState();
}

class _DesktopCalendarHeaderState extends State<DesktopCalendarHeader> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.viewType == CalendarView.DAY) {
      return Consumer<CalendarDayService>(
        builder: (_, provider, __) {
          return _HeaderContent(service: provider);
        },
      );
    } else {
      return Consumer<CalendarWeekService>(
        builder: (_, provider, __) {
          return _HeaderContent(service: provider);
        },
      );
    }
  }
}

class _HeaderContent extends StatelessWidget {
  const _HeaderContent({
    Key? key,
    required this.service,
  }) : super(key: key);
  final CalenderBaseService service;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: service.isFetching ? null : () => service.gotoToday(),
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
          ),
          child: const Text('Today', style: TextStyle(color: Colors.black)),
        ),
        InkWell(
          onTap: service.isFetching
              ? null
              : () {
                  service.gotoPrevious();
                },
          child: const Icon(
            Icons.keyboard_arrow_left_rounded,
          ),
        ),
        Text(
          service.headerMonth,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        InkWell(
          onTap: service.isFetching
              ? null
              : () {
                  service.gotoNext();
                },
          child: const Icon(
            Icons.keyboard_arrow_right_rounded,
          ),
        ),
        const Spacer(),
        _DayWeekButton(service: service),
        const SizedBox(width: 20),
        SizedBox(
          height: 35,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(elevation: 4),
            child: const Text('Add Appointment'),
          ),
        ),
      ],
    );
  }
}

class _DayWeekButton extends StatelessWidget {
  const _DayWeekButton({required this.service});
  final CalenderBaseService service;

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarViewService>(builder: (_, provider, __) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Constants.primaryColor, width: 1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Card(
              elevation: 0,
              color: provider.isDayView
                  ? Constants.primaryColor
                  : Colors.transparent,
              child: InkWell(
                onTap: service.isFetching
                    ? null
                    : () {
                        service.gotoToday();
                        provider.changeView(CalendarView.DAY);
                      },
                child: Container(
                  width: 60,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  child: Text(
                    'Day',
                    style: TextStyle(
                      color: provider.isDayView ? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Card(
              elevation: 0,
              color: provider.isWeekView
                  ? Constants.primaryColor
                  : Colors.transparent,
              child: InkWell(
                onTap: service.isFetching
                    ? null
                    : () {
                        service.gotoToday();
                        provider.changeView(CalendarView.WEEK);
                      },
                child: Container(
                  width: 60,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  child: Text(
                    'Week',
                    style: TextStyle(
                      color: provider.isWeekView ? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
