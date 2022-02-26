import 'package:acservermanager/common/appearance_bloc/appearance_bloc.dart';
import 'package:acservermanager/common/shared_manager.dart';
import 'package:acservermanager/models/enums/shared_key.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get_it/get_it.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final AppearanceBloc _bloc;

  @override
  void initState() {
    _bloc = GetIt.I<AppearanceBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _bloc.backgroundColor,
      child: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          StreamBuilder<bool>(
              stream: _bloc.darkMode,
              initialData: true,
              builder: (context, snapshot) {
                return ToggleSwitch(
                  content: const Text('Dark Mode'),
                  checked: snapshot.data!,
                  onChanged: (value) {
                    _bloc.setDarkMode(value: value);
                  },
                );
              }),
          ToggleSwitch(
            content: const Text(
                'Close the dialog when the selected server is changed'),
            checked: GetIt.I<SharedManager>().getBool(SharedKey.closeDialog) ??
                false,
            onChanged: (value) {
              GetIt.I<SharedManager>().setBool(SharedKey.closeDialog, value);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
