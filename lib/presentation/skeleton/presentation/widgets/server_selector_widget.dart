import 'package:acservermanager/models/server.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get_it/get_it.dart';

class ServerSelectorWidget extends StatefulWidget {
  final List<Server> servers;
  const ServerSelectorWidget({
    Key? key,
    required this.servers,
  }) : super(key: key);

  @override
  _ServerSelectorWidgetState createState() => _ServerSelectorWidgetState();
}

class _ServerSelectorWidgetState extends State<ServerSelectorWidget> {
  final FlyoutController _flyoutController = FlyoutController();

  @override
  Widget build(BuildContext context) {
    return DropDownButton(
      controller: _flyoutController,
      items: List.generate(
        widget.servers.length,
        (index) => DropDownButtonItem(
          onTap: () {
            GetIt.instance.registerSingleton(widget.servers[index]);
          },
          title: Text(widget.servers[index].name),
        ),
      ),
    );
  }
}
