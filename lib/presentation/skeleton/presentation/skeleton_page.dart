import 'package:acservermanager/common/inherited_widgets/selected_server_inherited.dart';
import 'package:acservermanager/models/server.dart';
import 'package:acservermanager/presentation/advanced_server_settings/presentation/advanced_server_settings.dart';
import 'package:acservermanager/presentation/server_main_settings_page/server_main_settings_page.dart';
import 'package:acservermanager/presentation/settings/settings_page.dart';
import 'package:acservermanager/presentation/skeleton/bloc/skeleton_bloc.dart';
import 'package:acservermanager/presentation/skeleton/presentation/bloc/session_bloc.dart';
import 'package:acservermanager/presentation/skeleton/presentation/widgets/server_selector_widget.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class SkeletonPage extends StatelessWidget {
  SkeletonPage({Key? key}) : super(key: key);

  final SkeletonBloc _bloc = SkeletonBloc();

  final SessionBloc _sessionBloc = SessionBloc();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionBloc, SessionState>(
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
      child: SelectedServerInheritedWidget(
        selectedServer: GetIt.I<List<Server>>().first,
        child: StreamBuilder<int>(
          stream: _bloc.currentPage,
          initialData: 0,
          builder: (context, snapshot) {
            return StreamBuilder<bool>(
              stream: _bloc.panelOpen,
              initialData: true,
              builder: (context, panelOpenSnapshot) {
                return NavigationView(
                  content: NavigationBody(
                    index: snapshot.data!,
                    children: const [
                      ServerMainSettings(),
                      AdvancedServerSettings(),
                      SettingsPage(),
                    ],
                  ),
                  pane: NavigationPane(
                    onChanged: _bloc.changePage,
                    menuButton: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: panelOpenSnapshot.data!
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(material.Icons.menu),
                            onPressed: () {
                              _bloc.changePaneOpen(!panelOpenSnapshot.data!);
                            },
                          ),
                        ],
                      ),
                    ),
                    displayMode: panelOpenSnapshot.data!
                        ? PaneDisplayMode.open
                        : PaneDisplayMode.compact,
                    selected: snapshot.data!,
                    header: Button(
                      child: const Text('Select server'),
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
            );
          },
        ),
      ),
    );
  }
}
