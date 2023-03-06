import 'package:flutter/material.dart';
import 'package:medstar_appointment/model/customer.dart';
import 'package:medstar_appointment/services/customer_service.dart';
import 'package:medstar_appointment/utility/constants.dart';
import 'package:medstar_appointment/view/desktop/components/divider.dart';
import 'package:medstar_appointment/view/desktop/components/vnavbar.dart';
import 'package:medstar_appointment/view/desktop/customer/base_card.dart';
import 'package:provider/provider.dart';

class DesktopAddCustomer extends StatefulWidget {
  const DesktopAddCustomer({super.key, required this.goToPage});
  final Function goToPage;

  @override
  State<DesktopAddCustomer> createState() => _DesktopAddCustomerState();
}

class _DesktopAddCustomerState extends State<DesktopAddCustomer> {
  final _formKey = GlobalKey<FormState>();
  late String firstname;
  late String lastname;
  late String phoneNo;
  late String email;
  final TextEditingController _dobController = TextEditingController();
  late String? note;

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
                    'Add New Customer',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 35,
                    child:
                        Consumer<CustomerService>(builder: (_, provider, __) {
                      return ElevatedButton(
                        onPressed: provider.isAdding
                            ? null
                            : () {
                                widget.goToPage(
                                    DesktopCustomerPageConstants.listPage);
                              },
                        child: const Text('Cancel'),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Consumer<CustomerService>(builder: (_, provider, __) {
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
                          return 'Please enter first name';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        firstname = newValue ?? '';
                      },
                      decoration: Constants.textDecoration
                          .copyWith(labelText: 'First Name'),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    child: TextFormField(
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter last name';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        lastname = newValue ?? '';
                      },
                      decoration: Constants.textDecoration
                          .copyWith(labelText: 'Last Name'),
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
                          return 'Please enter a phone number';
                        }
                        if (value.length != 10) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        phoneNo = newValue ?? '';
                      },
                      decoration: Constants.textDecoration.copyWith(
                        labelText: 'Phone Number',
                        prefix: const Text('+1 '),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    child: TextFormField(
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        email = newValue ?? '';
                      },
                      decoration: Constants.textDecoration
                          .copyWith(labelText: 'Email Address'),
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
                      controller: _dobController,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select date of birth';
                        }
                        return null;
                      },
                      onTap: () async {
                        DateTime? dob = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1901),
                          lastDate: DateTime.now(),
                        );
                        if (dob != null) {
                          _dobController.text =
                              dob.toIso8601String().split('T')[0];
                        }
                      },
                      readOnly: true,
                      keyboardType: TextInputType.datetime,
                      decoration: Constants.textDecoration
                          .copyWith(labelText: 'Date of Birth'),
                    ),
                  ),
                ),
                Flexible(child: Container()),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              child: TextFormField(
                minLines: 5,
                maxLines: 5,
                onSaved: (newValue) {
                  note = newValue;
                },
                decoration: Constants.textDecoration.copyWith(
                  labelText: 'Note',
                  contentPadding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                ),
              ),
            ),
            Consumer<CustomerService>(
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
                              CustomerModel customer = CustomerModel(
                                firstName: firstname,
                                lastName: lastname,
                                phone: phoneNo,
                                email: email,
                                dob: _dobController.text,
                                note: note,
                              );
                              String? error = await provider.add(customer);
                              if (error == null) {
                                _formKey.currentState!.reset();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Customer Saved Successfully'),
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
