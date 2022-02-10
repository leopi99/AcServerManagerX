import 'package:fluent_ui/fluent_ui.dart';

class TextBoxEntryWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? placeHolder;

  const TextBoxEntryWidget({
    Key? key,
    required this.controller,
    required this.label,
    this.placeHolder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width * .4,
            child: TextBox(
              controller: controller,
              placeholder: placeHolder ?? label,
            ),
          ),
        ],
      ),
    );
  }
}
