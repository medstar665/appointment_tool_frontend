import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:medstar_appointment/model/appointment.dart';
import 'package:medstar_appointment/model/customer.dart';
import 'package:medstar_appointment/model/service.dart';
import 'package:medstar_appointment/services/appointment_service.dart';
import 'package:medstar_appointment/services/customer_service.dart';
import 'package:medstar_appointment/services/services_service.dart';
import 'package:medstar_appointment/services/user_management.dart';
import 'package:medstar_appointment/utility/constants.dart';
import 'package:medstar_appointment/view/desktop/appointment/home.dart';
import 'package:medstar_appointment/view/desktop/components/divider.dart';
import 'package:medstar_appointment/view/desktop/components/number_text_field.dart';
import 'package:medstar_appointment/view/desktop/components/vnavbar.dart';
import 'package:provider/provider.dart';
import 'package:time_picker_widget/time_picker_widget.dart' as timePicker;

class DesktopAddAppointment extends StatefulWidget {
  const DesktopAddAppointment({super.key, required this.goToPage});
  final Function goToPage;

  @override
  State<DesktopAddAppointment> createState() => _DesktopAddAppointmentState();
}

class _DesktopAddAppointmentState extends State<DesktopAddAppointment> {
  final _formKey = GlobalKey<FormState>();
  late final List<CustomerModel> _customers;
  late final List<ServiceModel> _services;
  late CustomerModel selectedCustomer;
  late ServiceModel selectedService;
  final TextEditingController _customerSearchController =
      TextEditingController();
  final TextEditingController _serviceSearchController =
      TextEditingController();
  final TextEditingController appointmentDate = TextEditingController();
  final TextEditingController appointmentTime = TextEditingController();
  // int? duration;
  TextEditingController durationController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  Color pickedColor = Color(0xFF2196F3);
  Function? durationColorSetState;

  void changeColor(Color pickedColor) {
    this.pickedColor = pickedColor;
  }

  Future<bool> _loadCustomersAndServices() async {
    _customers = await CustomerService().getCustomerNames();
    _services = await ServiceService().getAllServices();
    if (_customers.isEmpty) {
      _customers.insert(0, CustomerModel());
    }
    if (_services.isEmpty) {
      _services.insert(0, ServiceModel());
    }
    selectedCustomer = _customers[0];
    selectedService = _services[0];
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double cardViewWidth = MediaQuery.of(context).size.width -
        NavbarConstants.navbarWidth -
        (Constants.cardLeftMargin + Constants.cardRightMargin) -
        40;
    return FutureBuilder(
      future: _loadCustomersAndServices(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Failed to load data',
              style: TextStyle(fontSize: 30, color: Colors.grey),
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                strokeWidth: 5,
              ),
            ),
          );
        }
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
                        'Add New Appointment',
                        style: TextStyle(fontSize: 20),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 35,
                        child: Consumer<AppointmentService>(
                            builder: (_, provider, __) {
                          return ElevatedButton(
                            onPressed: provider.isAdding
                                ? null
                                : () {
                                    widget.goToPage(
                                        DesktopAppointmentPageConstants
                                            .listPage);
                                  },
                            child: const Text('All Appointments'),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Consumer<AppointmentService>(builder: (_, provider, __) {
                  return Stack(
                    children: [
                      const CustomDivider(),
                      if (provider.isAdding)
                        const LinearProgressIndicator(minHeight: 2.5),
                    ],
                  );
                }),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        child: StatefulBuilder(
                          builder: (context, dropDownSetState) {
                            return DropdownButton2<CustomerModel>(
                              isExpanded: true,
                              underline: Container(),
                              barrierLabel: 'Customer',
                              buttonDecoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black54, width: 1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              buttonPadding: const EdgeInsets.only(right: 10),
                              dropdownPadding:
                                  const EdgeInsets.fromLTRB(5, 10, 5, 0),
                              items: _customers.map((e) {
                                return DropdownMenuItem<CustomerModel>(
                                  value: e,
                                  child: Text(
                                    '${e.firstName} ${e.lastName}(${e.email})',
                                  ),
                                );
                              }).toList(),
                              value: selectedCustomer,
                              onChanged: (value) => dropDownSetState(() {
                                selectedCustomer = value!;
                              }),
                              searchController: _customerSearchController,
                              searchMatchFn: (item, searchValue) {
                                bool result = (item.value as CustomerModel)
                                        .firstName!
                                        .contains(searchValue) ||
                                    (item.value as CustomerModel)
                                        .lastName!
                                        .contains(searchValue) ||
                                    (item.value as CustomerModel)
                                        .email!
                                        .contains(searchValue);
                                return result;
                              },
                              searchInnerWidget: TextField(
                                controller: _customerSearchController,
                                decoration: Constants.textDecoration
                                    .copyWith(hintText: 'Search'),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        child: StatefulBuilder(
                          builder: (context, dropDownSetState) {
                            return DropdownButton2<ServiceModel>(
                              isExpanded: true,
                              underline: Container(),
                              buttonDecoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black54, width: 1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              buttonPadding: const EdgeInsets.only(right: 10),
                              dropdownPadding:
                                  const EdgeInsets.fromLTRB(5, 10, 5, 0),
                              items: _services.map((e) {
                                return DropdownMenuItem<ServiceModel>(
                                  value: e,
                                  child: Text(
                                    '${e.title} - ${e.description ?? '?'}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              value: selectedService,
                              onChanged: (value) {
                                if (colorController.text.isEmpty) {
                                  colorController.text =
                                      value!.color == null ? '' : value.color!;
                                  durationColorSetState!(() {});
                                } else if (selectedService.color ==
                                    colorController.text) {
                                  colorController.text =
                                      value!.color == null ? '' : value.color!;
                                  durationColorSetState!(() {});
                                }
                                if (durationController.text.isEmpty) {
                                  durationController.text =
                                      value!.duration == null
                                          ? ''
                                          : '${value.duration}';
                                } else if ('${selectedService.duration}' ==
                                    durationController.text) {
                                  durationController.text =
                                      value!.duration == null
                                          ? ''
                                          : '${value.duration}';
                                }
                                dropDownSetState(() {
                                  selectedService = value!;
                                });
                              },
                              searchController: _serviceSearchController,
                              searchMatchFn: (item, searchValue) {
                                bool result = (item.value as ServiceModel)
                                        .title!
                                        .contains(searchValue) ||
                                    '${(item.value as ServiceModel).description}'
                                        .contains(searchValue);
                                return result;
                              },
                              searchInnerWidget: TextField(
                                controller: _serviceSearchController,
                                decoration: Constants.textDecoration
                                    .copyWith(hintText: 'Search'),
                              ),
                            );
                          },
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
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a date';
                            }
                            return null;
                          },
                          onTap: () async {
                            DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                                selectableDayPredicate: (DateTime val) =>
                                    !(val.weekday == 6 || val.weekday == 7));
                            if (date != null) {
                              appointmentDate.text =
                                  date.toIso8601String().split('T')[0];
                            }
                          },
                          readOnly: true,
                          controller: appointmentDate,
                          decoration: Constants.textDecoration
                              .copyWith(labelText: 'Appointment Date'),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        child: TextFormField(
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a time';
                            }
                            return null;
                          },
                          onTap: () async {
                            // TimeOfDay? time = await showTimePicker(
                            //   context: context,
                            //   initialTime: TimeOfDay.now(),
                            //   initialEntryMode: TimePickerEntryMode.dialOnly,
                            //   onEntryModeChanged: null,
                            // );
                            TimeOfDay? time =
                                await timePicker.showCustomTimePicker(
                              context: context,
                              initialTime: const TimeOfDay(hour: 8, minute: 0),
                              selectableTimePredicate: (time) {
                                return (time!.hour >= 7 && time.hour <= 19) &&
                                    time.minute % Constants.timeSlot == 0;
                              },
                              onFailValidation: (context) =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Please select a correct time.'),
                                ),
                              ),
                            );
                            if (time != null) {
                              String hr = time.hour < 10
                                  ? '0${time.hour}'
                                  : '${time.hour}';
                              String mins = time.minute < 10
                                  ? '0${time.minute}'
                                  : '${time.minute}';
                              appointmentTime.text = '$hr:$mins';
                            }
                          },
                          readOnly: true,
                          controller: appointmentTime,
                          decoration: Constants.textDecoration.copyWith(
                            labelText: 'Appointment Time',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                StatefulBuilder(builder: (context, durationColorSetState) {
                  this.durationColorSetState = durationColorSetState;
                  return Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          child: NumberTextField(
                            controller: durationController,
                            labelText: 'Duration',
                            suffixText: 'minutes',
                            stepper: Constants.timeSlot,
                            onSaved: (newValue) {
                              if (newValue != null && newValue.isNotEmpty) {
                                durationController.text = newValue;
                              }
                            },
                          ),
                          // child: TextFormField(
                          //   validator: (String? value) {
                          //     if (value != null && value.isNotEmpty) {
                          //       int val = int.parse(value);
                          //       if (val <= 0) {
                          //         return 'Please enter a valid duration';
                          //       }
                          //     }
                          //     return null;
                          //   },
                          //   onSaved: (newValue) {
                          //     if (newValue != null && newValue.isNotEmpty) {
                          //       duration = int.parse(newValue);
                          //     }
                          //   },
                          //   decoration: Constants.textDecoration.copyWith(
                          //     labelText: 'Duration',
                          //     suffix: const Text('minutes'),
                          //   ),
                          // ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          child: TextFormField(
                            controller: colorController,
                            onTap: () async {
                              bool? saveColor = await showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => AlertDialog(
                                  title: const Text('Pick a color'),
                                  content: MaterialPicker(
                                    pickerColor: pickedColor,
                                    onColorChanged: changeColor,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Clear'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                              if (saveColor == null) {
                                colorController.clear();
                                durationColorSetState(() {});
                              } else if (saveColor) {
                                colorController.text = pickedColor.value
                                    .toRadixString(16)
                                    .toUpperCase();
                                durationColorSetState(() {});
                              }
                            },
                            readOnly: true,
                            decoration: Constants.textDecoration.copyWith(
                              labelText: 'Color',
                              suffixIcon: Icon(
                                Icons.square_rounded,
                                color:
                                    Constants.getHexColor(colorController.text),
                                // colorController.text.isEmpty
                                // ? Colors.transparent
                                // : Color(int.parse(colorController.text, radix: 16)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                Consumer<AppointmentService>(
                  builder: (_, provider, __) {
                    return Center(
                      child: SizedBox(
                        height: 40,
                        width: 150,
                        child: ElevatedButton(
                          onPressed: provider.isAdding
                              ? null
                              : () async {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  _formKey.currentState!.save();
                                  AppointmentModel appointment =
                                      AppointmentModel(
                                    customerId: selectedCustomer.id!,
                                    serviceId: selectedService.id!,
                                    appointmentDateTime: DateTime.tryParse(
                                        '${appointmentDate.text}T${appointmentTime.text}'),
                                    duration: durationController.text.isNotEmpty
                                        ? int.tryParse(durationController.text)
                                        : null,
                                    color: colorController.text,
                                  );
                                  String? error =
                                      await provider.add(appointment);
                                  if (error == null) {
                                    _formKey.currentState!.reset();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Appointment Saved Successfully'),
                                      ),
                                    );
                                    provider.getAll();
                                    widget.goToPage(
                                        DesktopAppointmentPageConstants
                                            .listPage);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(error),
                                      ),
                                    );
                                  }
                                },
                          child:
                              Text(provider.isAdding ? 'Saving...' : 'Submit'),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
