import 'dart:io';

import 'package:acservermanager/common/logger.dart';
import 'package:acservermanager/models/server.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:rxdart/rxdart.dart';

class SelectedServerInherited extends InheritedWidget {
  final BehaviorSubject<Server> _selectedServerSubject;
  Server get selectedServer => _selectedServerSubject.value;
  Stream<Server> get selectedServerStream => _selectedServerSubject.stream;

  const SelectedServerInherited({
    required Widget child,
    required BehaviorSubject<Server> selectedServer,
    Key? key,
  })  : _selectedServerSubject = selectedServer,
        super(child: child, key: key);

  @override
  bool updateShouldNotify(SelectedServerInherited oldWidget) => true;

  static SelectedServerInherited of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SelectedServerInherited>()!;

  Future<void> changeServer(Server server, [bool saveFile = true]) async {
    _selectedServerSubject.add(server);
    if (!saveFile) return;
    Logger().log("Saving server cfg file");
    await _saveFile(server.toStringList(), server.cfgFilePath);
    Logger().log("Server cfg file saved");
    Logger().log("Saving entry_list file");
    List<String> data = [];
    int carIndex = 0;
    for (int i = 0; i < server.cars.length; i++) {
      for (int o = 0; o < server.cars[i].skins.length; o++) {
        data.add("""
[CAR_$carIndex]
MODEL=${server.cars[i].skins.first.path.split('/')[server.cars[i].skins.first.path.split('/').length - 3]}
SKIN=${server.cars[i].skins.first.path.split('/').last}
SPECTATOR_MODE=0
DRIVERNAME=${server.cars[i].skins.first.details?.driverName ?? ""}
TEAM=
GUID=
BALLAST=0
RESTRICTOR=0
""");
        carIndex++;
      }
    }
    await _saveFile(data, server.entryListPath);
    Logger().log("Server entry_list file saved");
  }

  Future<void> _saveFile(List<String> data, String filePath) async {
    final file = File(filePath);
    final link = file.openWrite();
    //NOTE: To check if on Linux the separator should be another
    link.writeAll(data, "\n");
    await link.flush();
    link.close();
  }
}
