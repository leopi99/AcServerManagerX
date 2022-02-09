import 'package:acservermanager/common/appearance_bloc/appearance_bloc.dart';
import 'package:acservermanager/common/inherited_widgets/selected_server_inherited.dart';
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
    Server server = SelectedServerInherited.of(context).selectedServer.server!;
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
        _buildTextBoxEntry(_nameController, 'Server Name', 'Server Name'),
        _buildTextBoxEntry(_passwordController, 'Password', 'Password'),
        _buildTextBoxEntry(
            _adminPasswordController, 'Admin Password', 'Admin Password'),
      ],
    );
  }

  Widget _buildTextBoxEntry(TextEditingController controller, String label,
      String textBoxPlaceholder) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width * .4,
            child: TextBox(
              controller: controller,
              placeholder: textBoxPlaceholder,
            ),
          ),
        ],
      ),
    );
  }
}
