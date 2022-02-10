import 'dart:async';

import 'package:acservermanager/common/appearance_bloc/appearance_bloc.dart';
import 'package:acservermanager/common/inherited_widgets/selected_server_inherited.dart';
import 'package:acservermanager/models/server.dart';
import 'package:acservermanager/presentation/advanced_server_settings/widgets/textbox_entry_widget.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get_it/get_it.dart';

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

  @override
  void didChangeDependencies() {
    sub = SelectedServerInherited.of(context)
        .selectedServerStream
        .listen((event) {
      _nameController.text = event.name;
      _passwordController.text = event.password ?? '';
      _adminPasswordController.text = event.adminPassword;
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
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
      child: ListView(
        children: [
          _buildServerBaseTextBox(),
        ],
      ),
    );
  }

  Widget _buildServerBaseTextBox() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextBoxEntryWidget(controller: _nameController, label: 'Server Name'),
        TextBoxEntryWidget(controller: _passwordController, label: 'Password'),
        TextBoxEntryWidget(
            controller: _adminPasswordController, label: 'Admin Password'),
      ],
    );
  }
}
