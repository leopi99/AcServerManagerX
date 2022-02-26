import 'package:acservermanager/common/inherited_widgets/selected_server_inherited.dart';
import 'package:acservermanager/common/shared_manager.dart';
import 'package:acservermanager/models/enums/shared_key.dart';
import 'package:acservermanager/models/server.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get_it/get_it.dart';

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
                //Closes the dialog if the setting is enabled
                if (GetIt.I<SharedManager>().getBool(SharedKey.closeDialog) ??
                    false) {
                  Navigator.pop(context);
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
