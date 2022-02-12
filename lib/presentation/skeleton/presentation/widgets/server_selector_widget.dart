import 'package:acservermanager/common/inherited_widgets/selected_server_inherited.dart';
import 'package:acservermanager/models/server.dart';
import 'package:fluent_ui/fluent_ui.dart';

class ServerSelectorWidget extends StatelessWidget {
  final List<Server> servers;
  const ServerSelectorWidget({
    Key? key,
    required this.servers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Server>(
      stream: SelectedServerInherited.of(context).selectedServerStream,
      initialData: SelectedServerInherited.of(context).selectedServer,
      builder: (context, snapshot) {
        return DropDownButton(
          title: Text(snapshot.data!.name),
          items: List.generate(
            servers.length,
            (index) => DropDownButtonItem(
              onTap: () {
                if (servers[index] != snapshot.data!) {
                  SelectedServerInherited.of(context)
                      .changeServer(servers[index]);
                }
              },
              title: Text(servers[index].name),
            ),
          ),
        );
      },
    );
  }
}
