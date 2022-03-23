import 'dart:async';

import 'package:acservermanager/common/appearance_bloc/appearance_bloc.dart';
import 'package:acservermanager/common/inherited_widgets/selected_server_inherited.dart';
import 'package:acservermanager/models/server.dart';
import 'package:acservermanager/presentation/advanced_server_settings/widgets/textbox_entry_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

class ServerAdvancedSettingsPage extends StatefulWidget {
  const ServerAdvancedSettingsPage({Key? key}) : super(key: key);

  @override
  State<ServerAdvancedSettingsPage> createState() =>
      _ServerAdvancedSettingsPageState();
}

class _ServerAdvancedSettingsPageState
    extends State<ServerAdvancedSettingsPage> {
  final TextEditingController _udpPortController = TextEditingController();
  final TextEditingController _tcpPortController = TextEditingController();
  final TextEditingController _httpPortController = TextEditingController();
  final TextEditingController _packetHzController = TextEditingController();
  late final StreamSubscription<Server> sub;

  ///Width of the numeric input fields
  late double _portsWidth;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      sub = SelectedServerInherited.of(context)
          .selectedServerStream
          .listen((event) {
        _udpPortController.text = event.udpPort.toString();
        _tcpPortController.text = event.tcpPort.toString();
        _httpPortController.text = event.httpPort.toString();
        _packetHzController.text = event.packetHz.toString();
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _portsWidth = MediaQuery.of(context).size.width * .1;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    sub.cancel();
    _udpPortController.dispose();
    _tcpPortController.dispose();
    _httpPortController.dispose();
    _packetHzController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GetIt.instance<AppearanceBloc>().backgroundColor,
      child: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          TextBoxEntryWidget(
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onTextChanged: (value) {
              SelectedServerInherited.of(context).changeServer(
                  SelectedServerInherited.of(context)
                      .selectedServer
                      .copyWith(udpPort: value));
            },
            controller: _udpPortController,
            label: 'udp_port'.tr(),
            textBoxWidth: _portsWidth,
            placeHolder: '9600',
          ),
          TextBoxEntryWidget(
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onTextChanged: (value) {
              SelectedServerInherited.of(context).changeServer(
                  SelectedServerInherited.of(context)
                      .selectedServer
                      .copyWith(tcpPort: value));
            },
            controller: _tcpPortController,
            label: 'tcp_port'.tr(),
            textBoxWidth: _portsWidth,
            placeHolder: '9600',
          ),
          TextBoxEntryWidget(
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onTextChanged: (value) {
              SelectedServerInherited.of(context).changeServer(
                  SelectedServerInherited.of(context)
                      .selectedServer
                      .copyWith(httpPort: value));
            },
            controller: _httpPortController,
            label: 'http_port'.tr(),
            textBoxWidth: _portsWidth,
            placeHolder: '9600',
          ),
          TextBoxEntryWidget(
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onTextChanged: (value) {
              final int? newValue = int.tryParse(value);
              SelectedServerInherited.of(context).changeServer(
                  SelectedServerInherited.of(context)
                      .selectedServer
                      .copyWith(packetHz: newValue));
            },
            controller: _packetHzController,
            label: 'packet_hz'.tr(),
            textBoxWidth: _portsWidth,
            placeHolder: '9600',
          ),
          const SizedBox(height: 16),
          _buildThreads()
        ],
      ),
    );
  }

  Widget _buildThreads() {
    return Row(
      children: [
        DropDownButton(
          placement: FlyoutPlacement.left,
          title: Text(
              "${SelectedServerInherited.of(context).selectedServer.threads} " +
                  "threads".tr()),
          items: List.generate(
            7,
            (index) => DropDownButtonItem(
              onTap: () {
                SelectedServerInherited.of(context).changeServer(
                    SelectedServerInherited.of(context)
                        .selectedServer
                        .copyWith(threads: index + 2));
                setState(() {});
              },
              title: Text("threads".tr()),
              leading: Text("${index + 2}"),
            ),
          ),
        ),
      ],
    );
  }
}
