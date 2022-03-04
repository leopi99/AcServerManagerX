import 'dart:io';

import 'package:acservermanager/common/inherited_widgets/selected_server_inherited.dart';
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
        onTap: () => _openSidePanel(context),
        child: Column(
          children: [
            Stack(
              children: [
                Image.file(File(car.defaultPreview),
                    filterQuality: FilterQuality.medium),
                if (SelectedServerInherited.of(context)
                    .selectedServer
                    .cars
                    .contains(car))
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: InfoBadge(
                            source: Text(
                              SelectedServerInherited.of(context)
                                  .selectedServer
                                  .cars
                                  .firstWhere((element) => element == car)
                                  .skins
                                  .length
                                  .toString(),
                            ),
                          ),
                        ),
                      ),
                    ],
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
