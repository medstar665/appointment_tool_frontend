import 'package:flutter/material.dart';
import 'package:medstar_appointment/model/appointment.dart';
import 'package:medstar_appointment/services/appointment_service.dart';
import 'package:medstar_appointment/utility/constants.dart';
import 'package:medstar_appointment/view/desktop/appointment/home.dart';
import 'package:medstar_appointment/view/desktop/components/divider.dart';
import 'package:medstar_appointment/view/desktop/components/searchbar.dart';
import 'package:medstar_appointment/view/desktop/components/vnavbar.dart';
import 'package:provider/provider.dart';

class DesktopListApointment extends StatefulWidget {
  const DesktopListApointment({super.key, required this.goToPage});
  final Function goToPage;

  @override
  State<DesktopListApointment> createState() => _DesktopListApointmentState();
}

class _DesktopListApointmentState extends State<DesktopListApointment> {
  @override
  Widget build(BuildContext context) {
    final double tableWidth = MediaQuery.of(context).size.width -
        NavbarConstants.navbarWidth -
        (Constants.cardLeftMargin + Constants.cardRightMargin);
    return Consumer<AppointmentService>(
      builder: (_, provider, __) => Column(
        children: [
          DesktopSearchbar(
            keyword: 'Appointment',
            serviceInstance: provider,
            goToPage: widget.goToPage,
            goToPageIndex: DesktopAppointmentPageConstants.addPage,
          ),
          const CustomDivider(),
          _AppointmentTableHeading(tableWidth: tableWidth),
          Stack(
            children: [
              const Divider(
                height: 2.5,
                thickness: 1,
                color: Colors.black54,
              ),
              if (provider.isSearchingAll)
                const LinearProgressIndicator(minHeight: 2.5),
            ],
          ),
          Expanded(
            child: _AppointmentTableData(
              provider: provider,
              tableWidth: tableWidth,
              goToPage: widget.goToPage,
            ),
          )
        ],
      ),
    );
  }
}

class _AppointmentTableHeading extends StatelessWidget {
  const _AppointmentTableHeading({required this.tableWidth});

  final double tableWidth;

  @override
  Widget build(BuildContext context) {
    final double boxWidth = (tableWidth - 150) / 6;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20),
            width: 50,
            child: const Text(
              '#',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            width: boxWidth,
            child: const Text(
              'Customer',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            width: boxWidth,
            child: const Text(
              'Service',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            width: boxWidth,
            child: const Text(
              'Date',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            width: boxWidth,
            child: const Text(
              'Time',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            width: boxWidth,
            child: const Text(
              'Status',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            width: boxWidth,
            child: const Text(
              'Duration',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            width: 100,
            child: const Text(
              'Color',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentTableData extends StatelessWidget {
  const _AppointmentTableData({
    required this.provider,
    required this.tableWidth,
    required this.goToPage,
  });

  final AppointmentService provider;
  final double tableWidth;
  final Function goToPage;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: provider.appointments.length,
        itemBuilder: (context, index) {
          final appointment = provider.appointments[index];
          return _AppointmentListItem(
            appointment: appointment,
            tableWidth: tableWidth,
            goToPage: goToPage,
          );
        });
  }
}

class _AppointmentListItem extends StatefulWidget {
  const _AppointmentListItem({
    Key? key,
    required this.appointment,
    required this.tableWidth,
    required this.goToPage,
  }) : super(key: key);

  final AppointmentModel appointment;
  final double tableWidth;
  final Function goToPage;

  @override
  State<_AppointmentListItem> createState() => _AppointmentListItemState();
}

class _AppointmentListItemState extends State<_AppointmentListItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final double boxWidth = (widget.tableWidth - 150) / 6;
    return StatefulBuilder(
      builder: (context, itemSetState) {
        return MouseRegion(
          cursor:
              _isHovering ? SystemMouseCursors.click : SystemMouseCursors.basic,
          onEnter: (event) => itemSetState(() {
            _isHovering = true;
          }),
          onExit: (event) => itemSetState(() {
            _isHovering = false;
          }),
          child: Consumer<AppointmentService>(builder: (_, provider, __) {
            return GestureDetector(
              onTap: () {
                provider.setViewAppointment(widget.appointment);
                widget.goToPage(DesktopAppointmentPageConstants.viewPage);
              },
              child: Column(
                children: [
                  Container(
                    color: _isHovering ? Colors.grey.shade200 : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 20),
                          width: 50,
                          child: Text('${widget.appointment.id}'),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 20),
                          width: boxWidth,
                          child: Text(
                              '${widget.appointment.customer!.firstName} ${widget.appointment.customer!.lastName}'),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 20),
                          width: boxWidth,
                          child: Text('${widget.appointment.service!.title}'),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 20),
                          width: boxWidth,
                          child: Text(widget.appointment.appointmentDateTime!
                              .toString()
                              .split(' ')[0]),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 20),
                          width: boxWidth,
                          child: Text(widget.appointment.appointmentDateTime!
                              .toString()
                              .split(' ')[1]
                              .substring(0, 5)),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 20),
                          width: boxWidth,
                          child: Text('${widget.appointment.status}'),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 20),
                          width: boxWidth,
                          child: Text(widget.appointment.duration == null
                              ? ''
                              : '${widget.appointment.duration} mins'),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 20),
                          width: 100,
                          child: Row(
                            children: [
                              if (widget.appointment.color != null)
                                Container(
                                  width: 50,
                                  height: 17,
                                  decoration: BoxDecoration(
                                    color:
                                        getHexColor(widget.appointment.color!),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // Container(
                        //   alignment: Alignment.centerLeft,
                        //   padding: const EdgeInsets.only(left: 5),
                        //   width: 40,
                        //   child: const Icon(
                        //     Icons.remove_red_eye,
                        //     size: 20,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  const CustomDivider(color: Colors.grey),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  Color getHexColor(String color) {
    color = color.toUpperCase().replaceAll('#', '');
    color = 'FF$color';
    int intColor = int.tryParse(color, radix: 16) ?? 0xFF000000;
    return Color(intColor);
  }
}
