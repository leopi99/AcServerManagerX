import 'dart:io';

import 'package:acservermanager/models/car.dart';
import 'package:fluent_ui/fluent_ui.dart';

class CarWidget extends StatelessWidget {
  final Car car;
  const CarWidget({
    Key? key,
    required this.car,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.file(File(car.defaultPreview)),
        Text(car.name),
      ],
    );
  }
}
