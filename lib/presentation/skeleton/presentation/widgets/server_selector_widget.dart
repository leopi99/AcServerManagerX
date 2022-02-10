import 'package:acservermanager/common/inherited_widgets/selected_server_inherited.dart';
import 'package:acservermanager/models/server.dart';
import 'package:fluent_ui/fluent_ui.dart';

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
    return StreamBuilder<Server>(
        stream: SelectedServerInherited.of(context).selectedServerStream,
        initialData: SelectedServerInherited.of(context).selectedServer,
        builder: (context, snapshot) {
          return DropDownButton(
            controller: _flyoutController,
            title: Text(snapshot.data!.name),
            contentWidth: 156,
            items: List.generate(
              widget.servers.length,
              (index) => DropDownButtonItem(
                onTap: () {
                  SelectedServerInherited.of(context)
                      .changeServer(widget.servers[index]);
                },
                title: Text(widget.servers[index].name),
              ),
            ),
          );
        });
  }
}
