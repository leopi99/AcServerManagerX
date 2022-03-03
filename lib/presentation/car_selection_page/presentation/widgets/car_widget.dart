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
        Stack(
          children: [
            Image.file(File(car.defaultPreview)),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 8),
                child: IconButton(
                  icon: const Icon(
                    FluentIcons.copy,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    debugPrint('Skins found: (${car.skins.length}):');
                    for (var element in car.skins) {
                      debugPrint(
                          'Skin name: ${element.details?.name} -> ${element.liveryPath}');
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        Text(car.name),
      ],
    );
  }
}
