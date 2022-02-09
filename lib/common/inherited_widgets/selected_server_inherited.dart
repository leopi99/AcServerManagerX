import 'package:acservermanager/models/server.dart';
import 'package:fluent_ui/fluent_ui.dart';

class SelectedServerInherited extends InheritedWidget {
  final SelectedServer _selectedServer;
  SelectedServer get selectedServer => _selectedServer;
  const SelectedServerInherited({
    required Widget child,
    required SelectedServer selectedServer,
    Key? key,
  })  : _selectedServer = selectedServer,
        super(child: child, key: key);

  @override
  bool updateShouldNotify(SelectedServerInherited oldWidget) =>
      oldWidget.selectedServer.server!.name != selectedServer.server!.name;

  static SelectedServerInherited of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SelectedServerInherited>()!;
}

class SelectedServer {
  Server? _server;
  Server? get server => _server;

  SelectedServer(this._server);

  void setServer(Server server) {
    _server = server;
  }
}
