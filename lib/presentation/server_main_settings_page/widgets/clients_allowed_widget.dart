import 'package:acservermanager/common/inherited_widgets/selected_server_inherited.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';

class ClientsAllowedWidget extends StatefulWidget {
  const ClientsAllowedWidget({Key? key}) : super(key: key);

  @override
  State<ClientsAllowedWidget> createState() => _ClientsAllowedWidgetState();
}

class _ClientsAllowedWidgetState extends State<ClientsAllowedWidget> {
  static const double _kMaxClients = 24;
  static const double _kMinClients = 1;
  double currentValue = 1;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        currentValue = SelectedServerInherited.of(context)
            .selectedServer
            .clientsAllowed
            .toDouble();
      });
    });
    super.initState();
  }

  void _updateServer(double value) {
    SelectedServerInherited.of(context).changeServer(
        SelectedServerInherited.of(context)
            .selectedServer
            .copyWith(clientsAllowed: value.toInt()));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: InfoLabel(
            label: "clients_allowed".tr() + ": ${currentValue.toInt()}",
            child: SizedBox(
              width: 256,
              child: Slider(
                value: currentValue,
                onChanged: (value) {
                  setState(() {
                    currentValue = value;
                  });
                },
                onChangeEnd: _updateServer,
                max: _kMaxClients,
                min: _kMinClients,
                divisions: _kMaxClients.toInt(),
              ),
            ),
          ),
        ),
        Button(
          child: Text(
              "Visualizza le macchine abilitate (${SelectedServerInherited.of(context).selectedServer.skinLength}/${SelectedServerInherited.of(context).selectedServer.clientsAllowed})"),
          onPressed: () {},
        ),
      ],
    );
  }
}
