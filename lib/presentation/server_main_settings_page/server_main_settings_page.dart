import 'package:acservermanager/common/appearance_bloc/appearance_bloc.dart';
import 'package:acservermanager/models/server.dart';
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

  @override
  void didChangeDependencies() {
    Server server = GetIt.I<List<Server>>().first;
    _nameController.text = server.name;
    _passwordController.text = server.password ?? '';
    _adminPasswordController.text = server.adminPassword;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
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
          const Text('Server base settings'),
          _buildServerBaseTextBox(),
        ],
      ),
    );
  }

  Widget _buildServerBaseTextBox() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextBox(
            controller: _nameController,
            placeholder: 'Server name',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextBox(
            controller: _passwordController,
            placeholder: 'Password',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextBox(
            controller: _adminPasswordController,
            placeholder: 'Admin Password',
          ),
        ),
      ],
    );
  }
}
