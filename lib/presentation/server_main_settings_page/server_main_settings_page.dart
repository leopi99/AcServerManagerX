import 'dart:async';

import 'package:acservermanager/common/appearance_bloc/appearance_bloc.dart';
import 'package:acservermanager/common/inherited_widgets/selected_server_inherited.dart';
import 'package:acservermanager/models/server.dart';
import 'package:acservermanager/presentation/advanced_server_settings/widgets/textbox_entry_widget.dart';
import 'package:acservermanager/presentation/server_main_settings_page/widgets/added_cars_widget.dart';
import 'package:acservermanager/presentation/server_main_settings_page/widgets/clients_allowed_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class ServerMainSettings extends StatefulWidget {
  const ServerMainSettings({Key? key}) : super(key: key);

  @override
  State<ServerMainSettings> createState() => _ServerMainSettingsState();
}

class _ServerMainSettingsState extends State<ServerMainSettings> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _adminPasswordController =
      TextEditingController();
  late StreamSubscription<Server> sub;
  final BehaviorSubject<bool> _showSelectedCars = BehaviorSubject.seeded(false);
  String _lastServerPath = "";

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      sub = SelectedServerInherited.of(context)
          .selectedServerStream
          .listen((event) {
        if (event.cfgFilePath != _lastServerPath) {
          _lastServerPath = event.cfgFilePath;
          _nameController.text = event.name;
          _passwordController.text = event.password ?? '';
          _adminPasswordController.text = event.adminPassword;
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _showSelectedCars.close();
    sub.cancel();
    _nameController.dispose();
    _passwordController.dispose();
    _adminPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GetIt.instance<AppearanceBloc>().backgroundColor,
      child: StreamBuilder<bool>(
        initialData: false,
        stream: _showSelectedCars.stream,
        builder: ((context, snapshot) {
          if (snapshot.data!) {
            return AddedCarsWidget(
              cars: SelectedServerInherited.of(context).selectedServer.cars,
              onClose: () {
                _showSelectedCars.add(false);
              },
            );
          }
          return ListView(
            padding: const EdgeInsets.all(32),
            children: [
              _buildServerBaseTextBox(),
              ClientsAllowedWidget(
                showSelectedCars: () {
                  _showSelectedCars.add(true);
                },
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildServerBaseTextBox() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextBoxEntryWidget(
          controller: _nameController,
          label: 'server_name'.tr(),
          onTextChanged: (value) {
            SelectedServerInherited.of(context).changeServer(
                SelectedServerInherited.of(context)
                    .selectedServer
                    .copyWith(name: value));
          },
        ),
        TextBoxEntryWidget(
          onTextChanged: (value) {
            SelectedServerInherited.of(context).changeServer(
                SelectedServerInherited.of(context)
                    .selectedServer
                    .copyWith(password: value));
          },
          controller: _passwordController,
          label: 'password'.tr(),
        ),
        TextBoxEntryWidget(
          onTextChanged: (value) {
            SelectedServerInherited.of(context).changeServer(
                SelectedServerInherited.of(context)
                    .selectedServer
                    .copyWith(adminPassword: value));
          },
          controller: _adminPasswordController,
          label: "admin".tr() + " " + "password".tr(),
        ),
      ],
    );
  }
}
