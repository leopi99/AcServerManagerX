import 'dart:io';

import 'package:acservermanager/common/logger.dart';
import 'package:acservermanager/common/shared_manager.dart';
import 'package:acservermanager/models/enums/shared_key.dart';
import 'package:acservermanager/models/server.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get_it/get_it.dart';
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

  ///Changes the current selected [Server]
  Future<void> changeServer(Server server, [bool saveFile = true]) async {
    _selectedServerSubject.add(server);
    if (saveFile) {
      //Saves the files in its preset dir
      await _saveServerFiles(server);
      //Copies the files in the cfg dir from the preset
      final String acPath =
          (await GetIt.I<SharedManager>().getString(SharedKey.acPath))!;
      final entryListFile = File("$acPath/server/cfg/entry_list.ini");
      final serverCfgFile = File("$acPath/server/cfg/server_cfg.ini");
      await entryListFile
          .writeAsString(await File(server.entryListPath).readAsString());
      await serverCfgFile
          .writeAsString(await File(server.cfgFilePath).readAsString());
    }
  }

  ///Saves the server files
  Future<void> _saveServerFiles(Server server) async {
    Logger().log("Saving cfg file", name: "Server");
    await _saveFile(server.toStringList(), server.cfgFilePath);
    Logger().log("cfg file saved", name: "Server");
    Logger().log("Saving entry_list file", name: "Server");
    List<String> data = [];
    int carIndex = 0;
    for (int i = 0; i < server.cars.length; i++) {
      for (var _ in server.cars[i].skins) {
        data.add("""
[CAR_$carIndex]
MODEL=${server.cars[i].path.split('/').last}
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
    Logger().log("entry_list file saved", name: "Server");
  }

  ///Saves a file
  Future<void> _saveFile(List<String> data, String filePath) async {
    final file = File(filePath);
    final link = file.openWrite();
    //NOTE: To check if on Linux the separator should be another
    link.writeAll(data, "\n");
    await link.flush();
    link.close();
  }
}
