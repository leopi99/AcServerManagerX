import 'dart:io';

import 'package:acservermanager/models/car.dart';
import 'package:acservermanager/presentation/car_selection_page/presentation/widgets/car_bottom_sheet.dart';
import 'package:fluent_ui/fluent_ui.dart';

class CarWidget extends StatelessWidget {
  final Car car;

  const CarWidget({
    Key? key,
    required this.car,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          _openSidePanel(context);
        },
        child: Column(
          children: [
            Stack(
              children: [
                Image.file(File(car.defaultPreview),
                    filterQuality: FilterQuality.medium),
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
        ),
      ),
    );
  }

  void _openSidePanel(BuildContext context) {
    showBottomSheet(
      context: context,
      builder: (context) {
        return CarBottomSheetWidget(
          car: car,
        );
      },
    );
  }
}
