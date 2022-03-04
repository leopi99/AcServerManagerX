import 'dart:io';

import 'package:acservermanager/common/inherited_widgets/selected_server_inherited.dart';
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

  List<CarSkin> _addedSkins = [];

  @override
  void initState() {
    _selectedSkin = widget.car.skins.first;
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      int index = SelectedServerInherited.of(context)
          .selectedServer
          .cars
          .indexOf(widget.car);
      if (index != -1) {
        _addedSkins = SelectedServerInherited.of(context)
            .selectedServer
            .cars
            .elementAt(index)
            .skins;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      showDivider: false,
      showHandle: false,
      description: Text(widget.car.name),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              _buildSelectedSkin(),
              _buildSkins(),
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

  Widget _buildSkins() {
    int index = 0;
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.car.skins.map((skin) {
          index++;
          return Row(
            children: [
              Checkbox(
                checked: _addedSkins.contains(skin),
                onChanged: (value) {
                  if (value!) {
                    debugPrint('Added skin');
                    _addSkinToServer(skin);
                  } else {
                    debugPrint('Removed skin');
                    _removeSkinFromServer(skin);
                  }
                },
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSkin = skin;
                  });
                },
                child: Text(skin.details?.cuteName ?? "Default $index"),
              )
            ],
          );
        }).toList(),
      ),
    );
  }

  void _addSkinToServer(CarSkin skin) {
    List<Car> cars = [];
    cars.addAll(SelectedServerInherited.of(context).selectedServer.cars);
    //Adds the skin to the car
    if (cars.contains(widget.car)) {
      List<CarSkin> skins = [];
      skins.addAll(cars.firstWhere((element) => element == widget.car).skins);
      skins.add(skin);
      cars
          .firstWhere((element) => element == widget.car)
          .copyWith(skins: skins);
    } else {
      cars.add(widget.car.copyWith(skins: [skin]));
    }
    //Updates the server with the skin
    SelectedServerInherited.of(context).changeServer(
        SelectedServerInherited.of(context)
            .selectedServer
            .copyWith(cars: cars));
    debugPrint(
        'Server: ${SelectedServerInherited.of(context).selectedServer.cars.first.skins}');
    setState(() {
      _addedSkins.add(skin);
    });
  }

  void _removeSkinFromServer(CarSkin skin) {
    List<Car> cars = [];
    cars.addAll(SelectedServerInherited.of(context).selectedServer.cars);

    List<CarSkin> skins = [];
    skins.addAll(cars.firstWhere((element) => element == widget.car).skins);
    skins.remove(skin);
    if (skins.isEmpty) {
      cars.remove(widget.car);
    } else {
      cars
          .firstWhere((element) => element == widget.car)
          .copyWith(skins: skins);
    }
    //Updates the server with the skin
    SelectedServerInherited.of(context).changeServer(
        SelectedServerInherited.of(context)
            .selectedServer
            .copyWith(cars: cars));
    setState(() {
      _addedSkins.remove(skin);
    });
  }
}
