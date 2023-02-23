import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:medstar_appointment/model/customer.dart';
import 'package:medstar_appointment/model/service.dart';
import 'package:medstar_appointment/services/appointment_service.dart';
import 'package:medstar_appointment/utility/constants.dart';
import 'package:medstar_appointment/view/desktop/appointment/home.dart';
import 'package:medstar_appointment/view/desktop/components/divider.dart';
import 'package:medstar_appointment/view/desktop/components/vnavbar.dart';
import 'package:provider/provider.dart';

class DesktopViewAppointment extends StatefulWidget {
  const DesktopViewAppointment({super.key, required this.goToPage});
  final Function goToPage;

  @override
  State<DesktopViewAppointment> createState() => _DesktopViewAppointmentState();
}

class _DesktopViewAppointmentState extends State<DesktopViewAppointment> {
  final _formKey = GlobalKey<FormState>();
  int? _appointmentId;
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _serviceController = TextEditingController();
  final TextEditingController appointmentDate = TextEditingController();
  final TextEditingController appointmentTime = TextEditingController();
  final TextEditingController duration = TextEditingController();
  TextEditingController colorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double cardViewWidth = MediaQuery.of(context).size.width -
        NavbarConstants.navbarWidth -
        (Constants.cardLeftMargin + Constants.cardRightMargin) -
        40;
    return Consumer<AppointmentService>(
      builder: (_, provider, __) {
        final appointment = provider.viewAppointment;
        _appointmentId = appointment.id;
        _customerController.text =
            '${appointment.customer!.firstName} ${appointment.customer!.lastName}(${appointment.customer!.email})';
        _serviceController.text =
            '${appointment.service!.title} - ${appointment.service!.description ?? '?'}';
        appointmentDate.text =
            appointment.appointmentDateTime!.toIso8601String().split('T')[0];
        appointmentTime.text = appointment.appointmentDateTime!
            .toIso8601String()
            .split('T')[1]
            .substring(0, 5);
        duration.text =
            appointment.duration == null ? '' : '${appointment.duration}';
        colorController.text =
            appointment.color == null ? '' : '${appointment.color}';
        return Form(
          key: _formKey,
          child: SizedBox(
            width: cardViewWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 17.5, 20, 17.5),
                  child: Row(
                    children: [
                      const Text(
                        'View Appointment',
                        style: TextStyle(fontSize: 20),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 35,
                        child: ElevatedButton(
                          onPressed: () {
                            widget.goToPage(
                                DesktopAppointmentPageConstants.editPage);
                          },
                          child: const Text('Edit Appointment'),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        height: 35,
                        child: ElevatedButton(
                          onPressed: () {
                            widget.goToPage(
                                DesktopAppointmentPageConstants.listPage);
                          },
                          child: const Text('All Appointments'),
                        ),
                      ),
                    ],
                  ),
                ),
                const CustomDivider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 17.5, 20, 17.5),
                  child: Text(
                    'Appointment #$_appointmentId (${appointment.status})',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        child: TextFormField(
                          enabled: false,
                          controller: _customerController,
                          decoration: Constants.disabledTextDecoration,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        child: TextFormField(
                          enabled: false,
                          controller: _serviceController,
                          decoration: Constants.disabledTextDecoration,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        child: TextFormField(
                          enabled: false,
                          controller: appointmentDate,
                          decoration: Constants.disabledTextDecoration
                              .copyWith(labelText: 'Appointment Date'),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        child: TextFormField(
                          enabled: false,
                          controller: appointmentTime,
                          decoration: Constants.disabledTextDecoration.copyWith(
                            labelText: 'Appointment Time',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        child: TextFormField(
                          controller: duration,
                          enabled: false,
                          decoration: Constants.disabledTextDecoration.copyWith(
                            labelText: 'Duration',
                            suffix: const Text('minutes'),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        child: TextFormField(
                          controller: colorController,
                          enabled: false,
                          decoration: Constants.disabledTextDecoration.copyWith(
                            labelText: 'Color',
                            suffixIcon: Icon(Icons.square_rounded,
                                color:
                                    Constants.getHexColor(colorController.text)
                                // colorController.text.isEmpty
                                //     ? Colors.transparent
                                //     : Color(int.parse(colorController.text, radix: 16)),
                                ),
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
      },
    );
  }
}
