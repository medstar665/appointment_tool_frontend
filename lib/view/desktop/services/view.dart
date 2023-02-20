import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:medstar_appointment/model/service.dart';
import 'package:medstar_appointment/services/services_service.dart';
import 'package:medstar_appointment/utility/constants.dart';
import 'package:medstar_appointment/view/desktop/components/divider.dart';
import 'package:medstar_appointment/view/desktop/components/vnavbar.dart';
import 'package:medstar_appointment/view/desktop/services/home.dart';
import 'package:provider/provider.dart';

class DesktopViewService extends StatefulWidget {
  const DesktopViewService({super.key, required this.goToPage});
  final Function goToPage;

  @override
  State<DesktopViewService> createState() => _DesktopViewServiceState();
}

class _DesktopViewServiceState extends State<DesktopViewService> {
  final _formKey = GlobalKey<FormState>();
  late final int? _serviceId;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();

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
                        'View Service',
                        style: TextStyle(fontSize: 20),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 35,
                        child: ElevatedButton(
                          onPressed: () {
                            widget
                                .goToPage(DesktopServicePageConstants.editPage);
                          },
                          child: const Text('Edit Service'),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        height: 35,
                        child: ElevatedButton(
                          onPressed: () {
                            widget
                                .goToPage(DesktopServicePageConstants.listPage);
                          },
                          child: const Text('All Services'),
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
                          controller: _titleController,
                          decoration: Constants.disabledTextDecoration
                              .copyWith(labelText: 'Title'),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        child: TextFormField(
                          controller: _descriptionController,
                          enabled: false,
                          decoration: Constants.disabledTextDecoration
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
                          enabled: false,
                          decoration: Constants.disabledTextDecoration.copyWith(
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
                          controller: _durationController,
                          enabled: false,
                          decoration: Constants.disabledTextDecoration.copyWith(
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
                        child: TextFormField(
                          controller: _colorController,
                          enabled: false,
                          decoration: Constants.disabledTextDecoration.copyWith(
                            labelText: 'Color',
                            suffixIcon: Icon(
                              Icons.square_rounded,
                              color: _colorController.text.isEmpty
                                  ? Colors.transparent
                                  : Color(int.parse(_colorController.text,
                                      radix: 16)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(child: Container()),
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
