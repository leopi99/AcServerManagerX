import 'package:acservermanager/models/server.dart';
import 'package:fluent_ui/fluent_ui.dart';

class SelectedServerInheritedWidget extends InheritedWidget {
  Server selectedServer;

  SelectedServerInheritedWidget({
    Key? key,
    required Widget child,
    required this.selectedServer,
  }) : super(child: child, key: key);

  static SelectedServerInheritedWidget of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<SelectedServerInheritedWidget>()!;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
