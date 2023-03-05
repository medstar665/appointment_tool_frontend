import 'package:flutter/material.dart';
import 'package:medstar_appointment/model/customer.dart';
import 'package:medstar_appointment/services/customer_service.dart';
import 'package:medstar_appointment/utility/constants.dart';
import 'package:medstar_appointment/view/desktop/components/divider.dart';
import 'package:medstar_appointment/view/desktop/components/vnavbar.dart';
import 'package:medstar_appointment/view/desktop/customer/base_card.dart';
import 'package:provider/provider.dart';

class DesktopEditCustomer extends StatefulWidget {
  const DesktopEditCustomer({super.key, required this.goToPage});
  final Function goToPage;

  @override
  State<DesktopEditCustomer> createState() => _DesktopEditCustomerState();
}

class _DesktopEditCustomerState extends State<DesktopEditCustomer> {
  final _formKey = GlobalKey<FormState>();
  int? _customerId;
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double cardViewWidth = MediaQuery.of(context).size.width -
        NavbarConstants.navbarWidth -
        (Constants.cardLeftMargin + Constants.cardRightMargin) -
        40;
    return Consumer<CustomerService>(
      builder: (_, provider, child) {
        final customer = provider.viewCustomer;
        _customerId = customer.id;
        _firstnameController.text = customer.firstName ?? '';
        _lastnameController.text = customer.lastName ?? '';
        _phoneNoController.text = customer.phone ?? '';
        _emailController.text = customer.email ?? '';
        _dobController.text = customer.dob ?? '';
        _noteController.text = customer.note ?? '';
        return child!;
      },
      child: Form(
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
                      'Edit Customer',
                      style: TextStyle(fontSize: 20),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 35,
                      child:
                          Consumer<CustomerService>(builder: (_, provider, __) {
                        return ElevatedButton(
                          onPressed: provider.isUpdating
                              ? null
                              : () {
                                  widget.goToPage(
                                      DesktopCustomerPageConstants.viewPage);
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
                        controller: _firstnameController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter first name';
                          }
                          return null;
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
                        controller: _lastnameController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter last name';
                          }
                          return null;
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
                        controller: _phoneNoController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a phone number';
                          }
                          if (value.length != 10) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
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
                        controller: _emailController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
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
                  controller: _noteController,
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
                        onPressed: provider.isUpdating
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                CustomerModel customer = CustomerModel(
                                  id: _customerId,
                                  firstName: _firstnameController.text,
                                  lastName: _lastnameController.text,
                                  phone: _phoneNoController.text,
                                  email: _emailController.text,
                                  dob: _dobController.text,
                                  note: _noteController.text,
                                );
                                String? error = await provider.update(customer);
                                if (error == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Customer Saved Successfully'),
                                    ),
                                  );
                                  provider.getAll();
                                  widget.goToPage(
                                      DesktopCustomerPageConstants.listPage);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(error),
                                    ),
                                  );
                                }
                              },
                        child:
                            Text(provider.isUpdating ? 'Saving...' : 'Submit'),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
