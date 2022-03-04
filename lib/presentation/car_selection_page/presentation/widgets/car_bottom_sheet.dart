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
  static const double _kImageWidthDiv = 2;
  late CarSkin _selectedSkin;

  List<CarSkin> _addedSkins = [];

  ///Skins that are available to the car
  List<List<CarSkin>> skins = [];

  @override
  void initState() {
    _selectedSkin = widget.car.skins.first;

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      int index = SelectedServerInherited.of(context)
          .selectedServer
          .cars
          .indexOf(widget.car);
      final int skinDiff = (MediaQuery.of(context).size.height ~/ 3) ~/ 24;
      //Creates the list of list of skins
      for (int i = 0; i < widget.car.skins.length; i += skinDiff) {
        if (i + skinDiff > widget.car.skins.length) {
          skins.add(widget.car.skins.sublist(i));
          break;
        } else {
          skins.add(widget.car.skins.sublist(i, i + skinDiff));
        }
      }
      if (index != -1) {
        _addedSkins = SelectedServerInherited.of(context)
            .selectedServer
            .cars
            .elementAt(index)
            .skins;
      }
      setState(() {});
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
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
      height: MediaQuery.of(context).size.height / _kImageWidthDiv,
      width: MediaQuery.of(context).size.height / _kImageWidthDiv,
    );
  }

  Widget _buildSkins() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16),
      child: LimitedBox(
        maxWidth: MediaQuery.of(context).size.width -
            32 -
            MediaQuery.of(context).size.height / _kImageWidthDiv,
        maxHeight: MediaQuery.of(context).size.height / 2.7,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: skins.map<Widget>((e) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: e.map<Widget>((skin) {
                  return Row(
                    children: [
                      Checkbox(
                        checked: _addedSkins.contains(skin),
                        onChanged: (value) {
                          if (value!) {
                            _addSkinToServer(skin);
                          } else {
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
                        child: Text(skin.details!.cuteName),
                      )
                    ],
                  );
                }).toList(),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  //Adds the skin (if the car is not already present, adds that too) to the selected cars in the server
  void _addSkinToServer(CarSkin skin) {
    List<Car> cars = [];
    cars.addAll(SelectedServerInherited.of(context).selectedServer.cars);
    //Adds the skin to the car
    if (cars.contains(widget.car)) {
      List<CarSkin> skins = [];
      skins.addAll(cars.firstWhere((element) => element == widget.car).skins);
      skins.add(skin);
      int carIndex = cars.indexWhere((element) => element == widget.car);
      cars[carIndex] = cars[carIndex].copyWith(skins: skins);
    } else {
      cars.add(widget.car.copyWith(skins: [skin]));
    }
    //Updates the server with the skin
    SelectedServerInherited.of(context).changeServer(
        SelectedServerInherited.of(context)
            .selectedServer
            .copyWith(cars: cars));
    setState(() {
      _addedSkins.add(skin);
    });
  }

  //Removes the skin (and the car if it has no more skins) from the selected cars in the server
  void _removeSkinFromServer(CarSkin skin) {
    List<Car> cars = [];
    cars.addAll(SelectedServerInherited.of(context).selectedServer.cars);

    List<CarSkin> skins = [];
    skins.addAll(cars.firstWhere((element) => element == widget.car).skins);
    skins.remove(skin);
    if (skins.isEmpty) {
      cars.remove(widget.car);
    } else {
      int carIndex = cars.indexWhere((element) => element == widget.car);
      cars[carIndex] = cars[carIndex].copyWith(skins: skins);
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
