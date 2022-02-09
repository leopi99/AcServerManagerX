import 'package:acservermanager/common/appearance_bloc/appearance_bloc.dart';
import 'package:acservermanager/common/inherited_widgets/selected_server_inherited.dart';
import 'package:acservermanager/models/server.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get_it/get_it.dart';

class AdvancedServerSettings extends StatefulWidget {
  const AdvancedServerSettings({Key? key}) : super(key: key);

  @override
  State<AdvancedServerSettings> createState() => _AdvancedServerSettingsState();
}

class _AdvancedServerSettingsState extends State<AdvancedServerSettings> {
  final TextEditingController _udpPortController = TextEditingController();
  final TextEditingController _tcpPortController = TextEditingController();
  final TextEditingController _httpPortController = TextEditingController();
  final TextEditingController _packetHzController = TextEditingController();

  @override
  void didChangeDependencies() {
    debugPrint('ServerAdvancedSettingsPage.didChangeDependencies');
    Server server = SelectedServerInherited.of(context).selectedServer.server!;
    _udpPortController.text = server.udpPort.toString();
    _tcpPortController.text = server.tcpPort.toString();
    _httpPortController.text = server.httpPort.toString();
    _packetHzController.text = server.packetHz.toString();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
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
          _buildTextBoxEntry(
              controller: _udpPortController,
              label: 'Udp port',
              textBoxPlaceholder: '9600'),
          _buildTextBoxEntry(
              controller: _tcpPortController,
              label: 'Tcp port',
              textBoxPlaceholder: '9600'),
          _buildTextBoxEntry(
              controller: _httpPortController,
              label: 'Http port',
              textBoxPlaceholder: '9600'),
          _buildTextBoxEntry(
              controller: _packetHzController,
              label: 'Packet Hz',
              textBoxPlaceholder: '9600'),
        ],
      ),
    );
  }

  Widget _buildTextBoxEntry(
      {required TextEditingController controller,
      required String label,
      required String textBoxPlaceholder}) {
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
