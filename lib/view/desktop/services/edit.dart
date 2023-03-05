import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:medstar_appointment/model/service.dart';
import 'package:medstar_appointment/services/services_service.dart';
import 'package:medstar_appointment/utility/constants.dart';
import 'package:medstar_appointment/view/desktop/components/divider.dart';
import 'package:medstar_appointment/view/desktop/components/number_text_field.dart';
import 'package:medstar_appointment/view/desktop/components/vnavbar.dart';
import 'package:medstar_appointment/view/desktop/services/base_card.dart';
import 'package:provider/provider.dart';

class DesktopEditService extends StatefulWidget {
  const DesktopEditService({super.key, required this.goToPage});
  final Function goToPage;

  @override
  State<DesktopEditService> createState() => _DesktopEditServiceState();
}

class _DesktopEditServiceState extends State<DesktopEditService> {
  final _formKey = GlobalKey<FormState>();
  late int? _serviceId;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  Color pickedColor = Color(0xFF2196F3);
  Function? colorSetState;

  void changeColor(Color pickedColor) {
    this.pickedColor = pickedColor;
  }

  @override
  Widget build(BuildContext context) {
    final double cardViewWidth = MediaQuery.of(context).size.width -
        NavbarConstants.navbarWidth -
        (Constants.cardLeftMargin + Constants.cardRightMargin) -
        40;
    return Consumer<ServiceService>(
      builder: (_, provider, __) {
        ServiceModel service = provider.viewService;
        _serviceId = service.id;
        _titleController.text = service.title!;
        _descriptionController.text = service.description!;
        _durationController.text =
            service.duration == null ? '' : '${service.duration}';
        _feeController.text = service.fee == null ? '' : '${service.fee}';
        _colorController.text = service.color!;
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
                        'Edit Service',
                        style: TextStyle(fontSize: 20),
                      ),
                      const Spacer(),
                      Consumer<ServiceService>(builder: (_, provider, __) {
                        return SizedBox(
                          height: 35,
                          child: ElevatedButton(
                            onPressed: provider.isUpdating
                                ? null
                                : () {
                                    widget.goToPage(
                                        DesktopServicePageConstants.viewPage);
                                  },
                            child: const Text('Cancel'),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                Consumer<ServiceService>(builder: (_, provider, __) {
                  return Stack(
                    children: [
                      const CustomDivider(),
                      if (provider.isUpdating)
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
                        child: TextFormField(
                          controller: _titleController,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the title';
                            }
                            return null;
                          },
                          decoration: Constants.textDecoration
                              .copyWith(labelText: 'Title'),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        child: TextFormField(
                          controller: _descriptionController,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the description';
                            }
                            return null;
                          },
                          decoration: Constants.textDecoration
                              .copyWith(labelText: 'Description'),
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
                          controller: _feeController,
                          validator: (String? value) {
                            if (value != null && value.isNotEmpty) {
                              int val = int.parse(value);
                              if (val <= 0) {
                                return 'Please enter a valid fee';
                              }
                            }
                            return null;
                          },
                          decoration: Constants.textDecoration.copyWith(
                            labelText: 'Fee',
                            prefix: const Text('\$ '),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        child: NumberTextField(
                          controller: _durationController,
                          labelText: 'Duration',
                          suffixText: 'minutes',
                          stepper: Constants.timeSlot,
                        ),
                        // child: TextFormField(
                        //   controller: _durationController,
                        //   validator: (String? value) {
                        //     if (value != null && value.isNotEmpty) {
                        //       int val = int.parse(value);
                        //       if (val <= 0) {
                        //         return 'Please enter a valid duration';
                        //       }
                        //     }
                        //     return null;
                        //   },
                        //   decoration: Constants.textDecoration.copyWith(
                        //     labelText: 'Duration',
                        //     suffix: const Text('minutes'),
                        //   ),
                        // ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        child:
                            StatefulBuilder(builder: (context, colorSetState) {
                          return TextFormField(
                            controller: _colorController,
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
                                _colorController.clear();
                                colorSetState(() {});
                              } else if (saveColor) {
                                _colorController.text = pickedColor.value
                                    .toRadixString(16)
                                    .toUpperCase();
                                colorSetState(() {});
                              }
                            },
                            readOnly: true,
                            decoration: Constants.textDecoration.copyWith(
                              labelText: 'Color',
                              suffixIcon: Icon(
                                Icons.square_rounded,
                                color: Constants.getHexColor(
                                    _colorController.text),
                                //  _colorController.text.isEmpty
                                // ? Colors.transparent
                                // : Color(int.parse(_colorController.text, radix: 16)),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    Flexible(child: Container()),
                  ],
                ),
                Consumer<ServiceService>(
                  builder: (_, provider, __) {
                    return Center(
                      child: SizedBox(
                        height: 40,
                        width: 150,
                        child: ElevatedButton(
                          onPressed: provider.isUpdating
                              ? null
                              : () async {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  _formKey.currentState!.save();
                                  ServiceModel service = ServiceModel(
                                    id: _serviceId,
                                    title: _titleController.text,
                                    description: _descriptionController.text,
                                    duration: _durationController
                                            .text.isNotEmpty
                                        ? int.tryParse(_durationController.text)
                                        : null,
                                    fee: _feeController.text.isNotEmpty
                                        ? int.tryParse(_feeController.text)
                                        : null,
                                    color: _colorController.text,
                                  );
                                  String? error =
                                      await provider.update(service);
                                  if (error == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Service Saved Successfully'),
                                      ),
                                    );
                                    provider.getAll();
                                    widget.goToPage(
                                        DesktopServicePageConstants.listPage);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(error),
                                      ),
                                    );
                                  }
                                },
                          child: Text(
                              provider.isUpdating ? 'Saving...' : 'Submit'),
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
