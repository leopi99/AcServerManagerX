import 'dart:io';

import 'package:acservermanager/models/car.dart';
import 'package:acservermanager/models/car/skin.dart';
import 'package:fluent_ui/fluent_ui.dart';

class CarBottomSheetWidget extends StatefulWidget {
  final Car car;
  const CarBottomSheetWidget({
    Key? key,
    required this.car,
  }) : super(key: key);

  @override
  State<CarBottomSheetWidget> createState() => _CarBottomSheetWidgetState();
}

class _CarBottomSheetWidgetState extends State<CarBottomSheetWidget> {
  late CarSkin _selectedSkin;

  @override
  void initState() {
    _selectedSkin = widget.car.skins.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      showDivider: false,
      showHandle: false,
      description: Text(widget.car.name),
      maxChildSize: .9,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              _buildSelectedSkin(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedSkin() {
    return Image.file(
      File(_selectedSkin.previewPath),
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.height / 3,
    );
  }
}
