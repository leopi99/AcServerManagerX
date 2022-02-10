import 'package:acservermanager/models/server.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:rxdart/rxdart.dart';

class SelectedServerInherited extends InheritedWidget {
  final BehaviorSubject<Server> _selectedServer;
  Server get selectedServer => _selectedServer.value;
  Stream<Server> get selectedServerStream => _selectedServer.stream;

  const SelectedServerInherited({
    required Widget child,
    required BehaviorSubject<Server> selectedServer,
    Key? key,
  })  : _selectedServer = selectedServer,
        super(child: child, key: key);

  @override
  bool updateShouldNotify(SelectedServerInherited oldWidget) => true;

  static SelectedServerInherited of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SelectedServerInherited>()!;

  void changeServer(Server server) => _selectedServer.add(server);
}
