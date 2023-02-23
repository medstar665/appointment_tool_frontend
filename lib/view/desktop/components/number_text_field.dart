import 'package:flutter/material.dart';
import 'package:medstar_appointment/utility/constants.dart';

class NumberTextField extends StatefulWidget {
  NumberTextField({
    super.key,
    this.controller,
    this.stepper = 1,
    this.suffixText = '',
    this.labelText = '',
    this.onSaved,
  });
  TextEditingController? controller;
  final int stepper;
  final String suffixText;
  final String labelText;
  Function? onSaved;

  @override
  State<NumberTextField> createState() => _NumberTextFieldState();
}

class _NumberTextFieldState extends State<NumberTextField> {
  late final TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _controller,
            readOnly: true,
            onSaved: (newValue) {
              if (widget.onSaved != null) {
                widget.onSaved!(newValue);
              }
            },
            decoration: Constants.textDecoration.copyWith(
              labelText: widget.labelText,
              suffixText: widget.suffixText,
            ),
          ),
        ),
        Column(
          children: [
            InkWell(
              onTap: () => setState(() {
                _controller.text =
                    '${(int.tryParse(_controller.text) ?? 0) + widget.stepper}';
              }),
              child: const Icon(Icons.arrow_drop_up),
            ),
            InkWell(
              onTap: _controller.text.isEmpty
                  ? null
                  : () => setState(() {
                        _controller.text =
                            '${((int.tryParse(_controller.text) ?? 0) - widget.stepper) == 0 ? '' : (int.tryParse(_controller.text) ?? 0) - widget.stepper}';
                      }),
              child: Icon(
                Icons.arrow_drop_down,
                color: _controller.text.isEmpty ? Colors.grey : Colors.black,
              ),
            ),
          ],
        )
      ],
    );
  }
}
