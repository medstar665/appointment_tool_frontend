import 'package:flutter/material.dart';
import 'package:medstar_appointment/model/customer.dart';
import 'package:medstar_appointment/services/customer_service.dart';
import 'package:medstar_appointment/utility/constants.dart';
import 'package:medstar_appointment/view/desktop/components/divider.dart';
import 'package:medstar_appointment/view/desktop/components/vnavbar.dart';
import 'package:medstar_appointment/view/desktop/customer/home.dart';
import 'package:provider/provider.dart';

class DesktopViewCustomer extends StatefulWidget {
  const DesktopViewCustomer({super.key, required this.goToPage});
  final Function goToPage;

  @override
  State<DesktopViewCustomer> createState() => _DesktopViewCustomerState();
}

class _DesktopViewCustomerState extends State<DesktopViewCustomer> {
  final _formKey = GlobalKey<FormState>();
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
                      'View Customer',
                      style: TextStyle(fontSize: 20),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 35,
                      child: ElevatedButton(
                        onPressed: () {
                          widget
                              .goToPage(DesktopCustomerPageConstants.editPage);
                        },
                        child: const Text('Edit Customer'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      height: 35,
                      child: ElevatedButton(
                        onPressed: () {
                          widget
                              .goToPage(DesktopCustomerPageConstants.listPage);
                        },
                        child: const Text('All Customers'),
                      ),
                    ),
                  ],
                ),
              ),
              const CustomDivider(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      child: TextFormField(
                        enabled: false,
                        controller: _firstnameController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter first name';
                          }
                          return null;
                        },
                        decoration: Constants.disabledTextDecoration
                            .copyWith(labelText: 'First Name'),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      child: TextFormField(
                        enabled: false,
                        controller: _lastnameController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter last name';
                          }
                          return null;
                        },
                        decoration: Constants.disabledTextDecoration
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
                        enabled: false,
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
                        decoration: Constants.disabledTextDecoration.copyWith(
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
                        enabled: false,
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
                        decoration: Constants.disabledTextDecoration
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
                        enabled: false,
                        controller: _dobController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select date of birth';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.datetime,
                        decoration: Constants.disabledTextDecoration
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
                  enabled: false,
                  decoration: Constants.disabledTextDecoration.copyWith(
                    labelText: 'Note',
                    contentPadding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
