import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';

class TextBoxEntryWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? placeHolder;
  final double? textBoxWidth;
  final Function(String)? onTextChanged;
  final List<TextInputFormatter> inputFormatters;

  const TextBoxEntryWidget({
    Key? key,
    required this.controller,
    required this.label,
    this.onTextChanged,
    this.textBoxWidth,
    this.placeHolder,
    this.inputFormatters = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0).copyWith(left: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 16),
          SizedBox(
            width: textBoxWidth ?? MediaQuery.of(context).size.width * .25,
            child: TextBox(
              controller: controller,
              onChanged: onTextChanged,
              inputFormatters: inputFormatters,
              placeholder: placeHolder ?? label,
            ),
          ),
        ],
      ),
    );
  }
}
