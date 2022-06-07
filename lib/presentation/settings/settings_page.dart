import 'package:acservermanager/common/appearance_bloc/appearance_bloc.dart';
import 'package:acservermanager/common/logger.dart';
import 'package:acservermanager/common/shared_manager.dart';
import 'package:acservermanager/models/enums/shared_key.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final AppearanceBloc _bloc;

  static const bool _kEnableUpdateCheck = false;

  static const String _kGitHubUrl = "";

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
              if (_kEnableUpdateCheck)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InfoBar(
                      title: Text(
                        "update_available".tr(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: Text("update_encourage".tr()),
                      severity: InfoBarSeverity.info,
                      action: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Button(
                          child: Text("update".tr()),
                          onPressed: () {
                            launchUrlString(_kGitHubUrl);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
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
              InfoLabel(
                label: 'app_language'.tr(),
                child: DropDownButton(
                  title: Text(context.locale.languageCode),
                  items: context.supportedLocales
                      .map(
                        (e) => MenuFlyoutItem(
                          leading: const Icon(FluentIcons.locale_language),
                          onPressed: () async {
                            await context.setLocale(e);
                          },
                          text: Text(e.languageCode),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
              InfoLabel(
                label: "clear_log_file_desc".tr(),
                child: FilledButton(
                  child: Text("clear_log_file".tr()),
                  onPressed: () => Logger().clearLogfile(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
