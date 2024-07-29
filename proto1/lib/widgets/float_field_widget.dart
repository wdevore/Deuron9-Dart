import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef SetValueF = void Function(double);

class FloatFieldWidget extends StatefulWidget {
  const FloatFieldWidget(
      {super.key,
      required this.label,
      required this.setValue,
      required this.controller});

  final TextEditingController controller;
  final String label;
  final SetValueF setValue;

  @override
  State<FloatFieldWidget> createState() => _FloatFieldWidgetState();
}

class _FloatFieldWidgetState extends State<FloatFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 5, 4),
            child: Text(widget.label),
          ),
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              inputFormatters: [FilteringFloatFormatter()],
              onChanged: (value) {
                widget.setValue(double.tryParse(value) ?? 0);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FilteringFloatFormatter extends TextInputFormatter {
  final _decimalFormatter =
      FilteringTextInputFormatter.allow(RegExp(r'\d+\.\d*'));
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    var decs = newValue.text.replaceAll(RegExp(r'[a-zA-Z]'), '');
    var value = _decimalFormatter.formatEditUpdate(
        oldValue, TextEditingValue(text: decs));
    var flt = value.text;
    return TextEditingValue(
        text: flt, selection: TextSelection.collapsed(offset: flt.length));
  }
}
