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
    final file = File(server.cfgFilePath);
    final link = file.openWrite();
    //NOTE: To check if on Linux the separator should be another
    link.writeAll(server.toStringList(), "\n");
    await link.flush();
    link.close();
    Logger().log("Server cfg file saved");
  }
}
