import 'package:flutter/material.dart';
import 'package:medstar_appointment/model/appointment.dart';
import 'package:medstar_appointment/services/appointment_service.dart';
import 'package:medstar_appointment/utility/constants.dart';
import 'package:medstar_appointment/view/desktop/appointment/base_card.dart';
import 'package:medstar_appointment/view/desktop/components/divider.dart';
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
          _SearchBar(
            serviceInstance: provider,
            goToPage: widget.goToPage,
            goToPageIndex: DesktopAppointmentPageConstants.addPage,
          ),
          // ExpansionPanel(headerBuilder: headerBuilder, body: body),
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

class _SearchBar extends StatefulWidget {
  const _SearchBar({
    required this.serviceInstance,
    required this.goToPage,
    required this.goToPageIndex,
  });
  final AppointmentService serviceInstance;
  final Function goToPage;
  final int goToPageIndex;

  @override
  State<_SearchBar> createState() => __SearchBarState();
}

class __SearchBarState extends State<_SearchBar> {
  bool _showSearch = false;
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  TextEditingController _keywordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Appointments',
                style: TextStyle(fontSize: 20),
              ),
              const Spacer(),
              IconButton(
                onPressed: widget.serviceInstance.isSearchingAll
                    ? null
                    : () {
                        if (_showSearch) {
                          bool hasChanged =
                              _keywordController.text.isNotEmpty ||
                                  _startDate != null ||
                                  _endDate != null;
                          _keywordController.text = '';
                          _startDateController.text = '';
                          _endDateController.text = '';
                          _startDate = null;
                          _endDate = null;
                          if (hasChanged) {
                            widget.serviceInstance.getAll();
                          }
                        }
                        setState(() {
                          _showSearch = !_showSearch;
                        });
                      },
                icon: Icon(_showSearch ? Icons.search_off : Icons.search),
              ),
              const SizedBox(width: 20),
              IconButton(
                onPressed: widget.serviceInstance.isSearchingAll
                    ? null
                    : () => widget.serviceInstance.getAll(),
                icon: const Icon(Icons.refresh),
              ),
              const SizedBox(width: 20),
              SizedBox(
                height: 35,
                child: ElevatedButton(
                  onPressed: () => widget.goToPage(widget.goToPageIndex),
                  style: ElevatedButton.styleFrom(elevation: 4),
                  child: const Text('Add Appointment'),
                ),
              ),
            ],
          ),
          if (_showSearch)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: size.width * 0.2,
                    height: 40,
                    child: TextField(
                      controller: _keywordController,
                      decoration: Constants.textDecoration.copyWith(
                        suffixIcon: const Icon(Icons.text_fields),
                        labelText: 'Keyword',
                      ),
                      onSubmitted: (String? val) {
                        widget.serviceInstance.getAll(search: val);
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: size.width * 0.2,
                    height: 40,
                    child: TextField(
                      controller: _startDateController,
                      decoration: Constants.textDecoration.copyWith(
                        suffixIcon: const Icon(
                          Icons.calendar_month_outlined,
                        ),
                        labelText: 'Start Date',
                      ),
                      onTap: () async {
                        DateTime? _date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (_date != null) {
                          _startDate = _date;
                          _startDateController.text =
                              _date.toIso8601String().split('T')[0];
                        }
                      },
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: size.width * 0.2,
                    height: 40,
                    child: TextField(
                      controller: _endDateController,
                      decoration: Constants.textDecoration.copyWith(
                        suffixIcon: const Icon(
                          Icons.calendar_month_outlined,
                        ),
                        labelText: 'End Date',
                      ),
                      onTap: () async {
                        DateTime? _date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (_date != null) {
                          _endDate = _date;
                          _endDateController.text =
                              _date.toIso8601String().split('T')[0];
                        }
                      },
                      readOnly: true,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.serviceInstance.getAll(
                          search: _keywordController.text,
                          startDate: _startDate,
                          endDate: _endDate,
                        );
                      },
                      style: ElevatedButton.styleFrom(elevation: 4),
                      child: const Text('Search'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.serviceInstance.downloadReport(
                          search: _keywordController.text,
                          startDate: _startDate,
                          endDate: _endDate,
                        );
                      },
                      style: ElevatedButton.styleFrom(elevation: 4),
                      child: const Text('Export'),
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
              style: TextStyle(fontSize: 17, fontStyle: FontStyle.italic),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            width: boxWidth,
            child: const Text(
              'Customer',
              style: TextStyle(fontSize: 17, fontStyle: FontStyle.italic),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            width: boxWidth,
            child: const Text(
              'Service',
              style: TextStyle(fontSize: 17, fontStyle: FontStyle.italic),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            width: boxWidth,
            child: const Text(
              'Date',
              style: TextStyle(fontSize: 17, fontStyle: FontStyle.italic),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            width: boxWidth,
            child: const Text(
              'Time',
              style: TextStyle(fontSize: 17, fontStyle: FontStyle.italic),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            width: boxWidth,
            child: const Text(
              'Status',
              style: TextStyle(fontSize: 17, fontStyle: FontStyle.italic),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            width: boxWidth,
            child: const Text(
              'Duration',
              style: TextStyle(fontSize: 17, fontStyle: FontStyle.italic),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            width: 100,
            child: const Text(
              'Color',
              style: TextStyle(fontSize: 17, fontStyle: FontStyle.italic),
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
                          child: Text(
                            '${widget.appointment.id}',
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 20),
                          width: boxWidth,
                          child: Text(
                            '${widget.appointment.customer!.firstName} ${widget.appointment.customer!.lastName}',
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 20),
                          width: boxWidth,
                          child: Text(
                            '${widget.appointment.service!.title}',
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 20),
                          width: boxWidth,
                          child: Text(
                            widget.appointment.appointmentDateTime!
                                .toString()
                                .split(' ')[0],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 20),
                          width: boxWidth,
                          child: Text(
                            widget.appointment.appointmentDateTime!
                                .toString()
                                .split(' ')[1]
                                .substring(0, 5),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 20),
                          width: boxWidth,
                          child: Row(
                            children: [
                              Icon(
                                Icons.album_outlined,
                                color: widget.appointment.status ==
                                        AppointmentStatus.Booked
                                    ? Colors.grey
                                    : widget.appointment.status ==
                                            AppointmentStatus.No_Show
                                        ? Colors.amber
                                        : widget.appointment.status ==
                                                AppointmentStatus.Completed
                                            ? Colors.green
                                            : widget.appointment.status ==
                                                    AppointmentStatus.Cancelled
                                                ? Colors.red
                                                : Colors.black,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '${widget.appointment.status}',
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 20),
                          width: boxWidth,
                          child: Text(
                            widget.appointment.duration == null
                                ? ''
                                : '${widget.appointment.duration} mins',
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 20),
                          width: 100,
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Constants.getHexColor(
                                      widget.appointment.color),
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
}
