import 'dart:io';

import 'package:acservermanager/common/shared_manager.dart';
import 'package:acservermanager/models/enums/shared_key.dart';
import 'package:acservermanager/models/server.dart';
import 'package:acservermanager/presentation/advanced_server_settings/presentation/server_advanced_settings.dart';
import 'package:acservermanager/presentation/server_main_settings_page/server_main_settings_page.dart';
import 'package:acservermanager/presentation/settings/settings_page.dart';
import 'package:acservermanager/presentation/skeleton/bloc/skeleton_bloc.dart';
import 'package:acservermanager/presentation/skeleton/presentation/bloc/session_bloc.dart';
import 'package:acservermanager/presentation/skeleton/presentation/widgets/server_selector_widget.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class SkeletonPage extends StatelessWidget {
  SkeletonPage({Key? key}) : super(key: key);

  final SkeletonBloc _bloc = SkeletonBloc();

  final SessionBloc _sessionBloc = SessionBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _sessionBloc,
      child: BlocListener<SessionBloc, SessionState>(
        bloc: _sessionBloc,
        listenWhen: (previous, current) => current is SessionLoadingState,
        listener: (context, state) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return const ContentDialog(
                content: ProgressRing(),
              );
            },
          );
        },
        child: StreamBuilder<int>(
          stream: _bloc.currentPage,
          initialData: 0,
          builder: (context, snapshot) {
            return NavigationView(
              content: NavigationBody(
                index: snapshot.data!,
                children: const [
                  ServerMainSettings(),
                  ServerAdvancedSettingsPage(),
                  SettingsPage(),
                ],
              ),
              pane: NavigationPane(
                onChanged: _bloc.changePage,
                displayMode: PaneDisplayMode.top,
                selected: snapshot.data!,
                header: SplitButtonBar(
                  style: SplitButtonThemeData(
                    interval: 4,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  buttons: [
                    SizedBox(
                      height: 24,
                      child: Button(
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('Select server'),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) => ContentDialog(
                              content: ServerSelectorWidget(
                                servers: GetIt.I<List<Server>>(),
                              ),
                              actions: [
                                FilledButton(
                                  child: const Text('Ok'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Button(
                      child: const Icon(FluentIcons.add),
                      onPressed: () async {
                        final Server server = Server(
                            serverFilesPath:
                                '${GetIt.I<SharedManager>().getString(SharedKey.acPath)}/server/preset'
                                '/SERVER_${(GetIt.I<List<Server>>().length + 1).toString().length != 2 ? "0" + (GetIt.I<List<Server>>().length + 1).toString() : (GetIt.I<List<Server>>().length + 1).toString()}');
                        if (GetIt.I<List<Server>>().length >= 4) {
                          //TODO: Create the dir SERVER_NUMBER
                          await Directory(server.serverFilesPath).create();
                        }
                        try {
                          final file = File(server.cfgFilePath);
                          await file
                              .writeAsString(server.toStringList().join('\n'));
                        } catch (e, stacktrace) {
                          debugPrint('Error: $e\nStacktrace:\n$stacktrace');
                          return;
                        }
                      },
                    ),
                  ],
                ),
                footerItems: [
                  PaneItem(
                    icon: const Icon(FluentIcons.settings),
                    title: const Text('Settings'),
                  ),
                ],
                items: [
                  PaneItem(
                    icon: const Icon(FluentIcons.server_enviroment),
                    title: const Text('Server main settings'),
                  ),
                  PaneItem(
                    icon: const Icon(FluentIcons.server_enviroment),
                    title: const Text('Server advanced settings'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
