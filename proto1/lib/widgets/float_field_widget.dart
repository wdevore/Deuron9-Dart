import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef SetValueF = void Function(double);

class FloatFieldWidget extends StatefulWidget {
  const FloatFieldWidget({
    super.key,
    required this.label,
    required this.setValue,
    required this.controller,
  });

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
            child: TextField(
              controller: widget.controller,
              // inputFormatters: [
              //   FilteringFloatFormatter(widget.controller.text.length)
              // ],
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

class FloatFieldWidget2 extends StatefulWidget {
  const FloatFieldWidget2({
    super.key,
    required this.label,
    required this.setValue,
    required this.controller,
    required this.cursorPos,
  });

  final TextEditingController controller;
  final String label;
  final SetValueF setValue;
  final int cursorPos;

  @override
  State<FloatFieldWidget2> createState() => _FloatFieldWidgetState2();
}

class _FloatFieldWidgetState2 extends State<FloatFieldWidget2> {
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
            child: TextField(
              controller: widget.controller,
              // inputFormatters: [FilteringFloatFormatter(widget.cursorPos)],
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
  int cursorPos;

  FilteringFloatFormatter(this.cursorPos);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    var decs = newValue.text.replaceAll(RegExp(r'[a-zA-Z]'), '');
    var value = _decimalFormatter.formatEditUpdate(
      oldValue,
      TextEditingValue(text: decs),
    );

    // if (cursorPos < 0) {
    cursorPos = value.text.length;
    // }

    print('formar ${cursorPos}');

    var textSelection = TextSelection.collapsed(offset: cursorPos);
    // var textSelection =
    //     TextSelection.fromPosition(TextPosition(offset: cursorPos));

    return TextEditingValue(text: value.text, selection: textSelection);
  }
}
