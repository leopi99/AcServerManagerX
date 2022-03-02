import 'dart:io';

import 'package:acservermanager/common/shared_manager.dart';
import 'package:acservermanager/models/enums/shared_key.dart';
import 'package:acservermanager/models/server.dart';
import 'package:acservermanager/presentation/advanced_server_settings/presentation/server_advanced_settings.dart';
import 'package:acservermanager/presentation/car_selection_page/presentation/car_selection_page.dart';
import 'package:acservermanager/presentation/server_main_settings_page/server_main_settings_page.dart';
import 'package:acservermanager/presentation/settings/settings_page.dart';
import 'package:acservermanager/presentation/skeleton/bloc/skeleton_bloc.dart';
import 'package:acservermanager/presentation/skeleton/presentation/bloc/session_bloc.dart';
import 'package:acservermanager/presentation/skeleton/presentation/widgets/server_selector_widget.dart';
import 'package:acservermanager/presentation/track_selection_page/presentation/track_selection_page.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class SkeletonPage extends StatefulWidget {
  const SkeletonPage({Key? key}) : super(key: key);

  @override
  State<SkeletonPage> createState() => _SkeletonPageState();
}

class _SkeletonPageState extends State<SkeletonPage> {
  final SkeletonBloc _bloc = SkeletonBloc();

  final SessionBloc _sessionBloc = SessionBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _sessionBloc,
      child: BlocListener<SessionBloc, SessionState>(
        bloc: _sessionBloc,
        listenWhen: (previous, current) =>
            current is SessionLoadingState ||
            current is SessionErrorState ||
            (previous is SessionLoadingState &&
                current is SessionTracksLoadedState),
        listener: (context, state) {
          debugPrint('CurrentState: $state');
          if (state is SessionLoadingState) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return const ContentDialog(
                  backgroundDismiss: false,
                  content: ProgressRing(),
                );
              },
            );
          } else if (state is SessionErrorState) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => ContentDialog(
                backgroundDismiss: false,
                title: Text(
                  'Ops! Something went wrong',
                  style: TextStyle(color: Colors.red),
                ),
                content: Text(state.error),
              ),
            );
          } else if (state is SessionTracksLoadedState) {
            //Pops the loading dialog
            Navigator.pop(context);
          }
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
                  TrackSelectionPage(),
                  CarSelectionPage(),
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
                              title: const Text('Select the server to edit'),
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
                      onPressed: () async => await _createServer(context),
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
                  PaneItem(
                    icon: const Icon(FluentIcons.exercise_tracker),
                    title: const Text('Track selection'),
                  ),
                  PaneItem(
                    icon: const Icon(FluentIcons.car),
                    title: const Text('Car selection'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _createServer(BuildContext context) async {
    bool create = false;
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ContentDialog(
        title: const Text('Create a new server?'),
        content: const Text(''),
        actions: [
          FilledButton(
            child: const Text('Ok'),
            onPressed: () {
              create = true;
              Navigator.pop(context);
            },
          ),
          Button(
            child: const Text('No'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
    if (!create) return;

    final List<int> _serverIndexes = GetIt.I<List<Server>>()
        .map(
            (e) => int.parse(e.serverFilesPath.split('/').last.split('_').last))
        .toList();
    //Finds the next available slot for the server
    int currentIndex = 0;
    for (var _ in _serverIndexes) {
      if (!_serverIndexes.contains(currentIndex)) {
        break;
      }
      currentIndex++;
    }
    String serverIndex = currentIndex.toString().length != 2
        ? "0" + currentIndex.toString()
        : currentIndex.toString();
    final Server server = Server(
        serverFilesPath:
            '${GetIt.I<SharedManager>().getString(SharedKey.acPath)}/server/preset/SERVER_$serverIndex');
    if (currentIndex >= 4) {
      await Directory(server.serverFilesPath).create();
    }
    try {
      final file = File(server.cfgFilePath);
      await file.writeAsString(server.toStringList().join('\n'));
    } catch (e, stacktrace) {
      debugPrint('Error: $e\nStacktrace:\n$stacktrace');
      return;
    }
  }
}
