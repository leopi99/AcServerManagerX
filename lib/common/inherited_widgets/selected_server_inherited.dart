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

  void changeServer(Server server) {
    _selectedServerSubject.add(server);
  }
}
