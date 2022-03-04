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
            Image.file(File(car.defaultPreview),
                filterQuality: FilterQuality.medium),
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
