import 'package:acservermanager/common/appearance_bloc/appearance_bloc.dart';
import 'package:acservermanager/common/shared_manager.dart';
import 'package:acservermanager/models/enums/shared_key.dart';
import 'package:easy_localization/easy_localization.dart';
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
    return StreamBuilder<bool>(
      stream: _bloc.darkMode,
      initialData: true,
      builder: (context, darkModeSnapshot) {
        return Container(
          color: _bloc.backgroundColor,
          child: ListView(
            padding: const EdgeInsets.all(32),
            children: [
              ToggleSwitch(
                content: Text('dark_mode'.tr()),
                checked: darkModeSnapshot.data!,
                onChanged: (value) {
                  _bloc.setDarkMode(value: value);
                },
              ),
              ToggleSwitch(
                content: Text('close_dialog_server_change'.tr()),
                checked:
                    GetIt.I<SharedManager>().getBool(SharedKey.closeDialog) ??
                        false,
                onChanged: (value) {
                  GetIt.I<SharedManager>()
                      .setBool(SharedKey.closeDialog, value);
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              Text('app_language'.tr()),
              const SizedBox(height: 8),
              Row(
                children: [
                  DropDownButton(
                    title: Text(context.locale.languageCode),
                    // leading: const Icon(FluentIcons.locale_language),
                    items: context.supportedLocales
                        .map(
                          (e) => DropDownButtonItem(
                            leading: const Icon(FluentIcons.locale_language),
                            onTap: () {
                              context.setLocale(e);
                            },
                            title: Text(e.languageCode),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
