import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:medstar_appointment/model/service.dart';
import 'package:medstar_appointment/services/services_service.dart';
import 'package:medstar_appointment/utility/constants.dart';
import 'package:medstar_appointment/view/desktop/components/divider.dart';
import 'package:medstar_appointment/view/desktop/components/vnavbar.dart';
import 'package:medstar_appointment/view/desktop/services/home.dart';
import 'package:provider/provider.dart';

class DesktopAddService extends StatefulWidget {
  const DesktopAddService({super.key, required this.goToPage});
  final Function goToPage;

  @override
  State<DesktopAddService> createState() => _DesktopAddServiceState();
}

class _DesktopAddServiceState extends State<DesktopAddService> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;
  int? duration;
  int? fee;
  TextEditingController colorController = TextEditingController();
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
                    'Add New Service',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 35,
                    child: Consumer<ServiceService>(builder: (_, provider, __) {
                      return ElevatedButton(
                        onPressed: provider.isAdding
                            ? null
                            : () {
                                widget.goToPage(
                                    DesktopServicePageConstants.listPage);
                              },
                        child: const Text('All Services'),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Consumer<ServiceService>(builder: (_, provider, __) {
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
                    child: TextFormField(
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the title';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        title = newValue ?? '';
                      },
                      decoration:
                          Constants.textDecoration.copyWith(labelText: 'Title'),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    child: TextFormField(
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the description';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        description = newValue ?? '';
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
                      validator: (String? value) {
                        if (value != null && value.isNotEmpty) {
                          int val = int.parse(value);
                          if (val <= 0) {
                            return 'Please enter a valid fee';
                          }
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        if (newValue != null && newValue.isNotEmpty) {
                          fee = int.parse(newValue);
                        }
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
                    child: TextFormField(
                      validator: (String? value) {
                        if (value != null && value.isNotEmpty) {
                          int val = int.parse(value);
                          if (val <= 0) {
                            return 'Please enter a valid duration';
                          }
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        if (newValue != null && newValue.isNotEmpty) {
                          duration = int.parse(newValue);
                        }
                      },
                      decoration: Constants.textDecoration.copyWith(
                        labelText: 'Duration',
                        suffix: const Text('minutes'),
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
                    child: StatefulBuilder(builder: (context, colorSetState) {
                      this.colorSetState = colorSetState;
                      return TextFormField(
                        controller: colorController,
                        onTap: () async {
                          bool? saveColor = await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => AlertDialog(
                              title: const Text('Pick a color'),
                              // content: BlockPicker(
                              //   pickerColor: pickedColor,
                              //   onColorChanged: changeColor,
                              // ),
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
                            colorSetState(() {});
                          } else if (saveColor) {
                            colorController.text = pickedColor.value
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
                            color: colorController.text.isEmpty
                                ? Colors.transparent
                                : Color(
                                    int.parse(colorController.text, radix: 16)),
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
                      onPressed: provider.isAdding
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              _formKey.currentState!.save();
                              ServiceModel customer = ServiceModel(
                                title: title,
                                description: description,
                                duration: duration,
                                fee: fee,
                                color: colorController.text,
                              );
                              String? error = await provider.add(customer);
                              if (error == null) {
                                _formKey.currentState!.reset();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Service Saved Successfully'),
                                  ),
                                );
                                provider.getAll();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(error),
                                  ),
                                );
                              }
                            },
                      child: Text(provider.isAdding ? 'Saving...' : 'Submit'),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
