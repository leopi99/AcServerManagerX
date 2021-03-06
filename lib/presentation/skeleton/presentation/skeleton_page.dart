import 'dart:async';
import 'dart:io';

import 'package:acservermanager/common/appearance_bloc/appearance_bloc.dart';
import 'package:acservermanager/common/inherited_widgets/selected_server_inherited.dart';
import 'package:acservermanager/common/shared_manager.dart';
import 'package:acservermanager/common/svg_paths.dart';
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
import 'package:acservermanager/server_run_istance.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

class SkeletonPage extends StatefulWidget {
  const SkeletonPage({Key? key}) : super(key: key);

  @override
  State<SkeletonPage> createState() => _SkeletonPageState();
}

class _SkeletonPageState extends State<SkeletonPage> {
  final SkeletonBloc _bloc = SkeletonBloc();

  final SessionBloc _sessionBloc = SessionBloc();

  late StreamSubscription<Server> _serverSubscription;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //Sets the current session
      _sessionBloc.add(SessionChangeSessionEvent(
          SelectedServerInherited.of(context).selectedServer.session));
      //Sets the session for the current selected server
      _serverSubscription = SelectedServerInherited.of(context)
          .selectedServerStream
          .listen((server) {
        _sessionBloc.add(SessionChangeSessionEvent(server.session));
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _sessionBloc.close();
    _bloc.dispose();
    _serverSubscription.cancel();
    super.dispose();
  }

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
                (current is SessionTracksLoadedState ||
                    current is SessionCarsLoadedState)),
        listener: (context, state) {
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
              barrierDismissible: !state.isCritic,
              builder: (context) => ContentDialog(
                backgroundDismiss: !state.isCritic,
                title: Text(
                  state.message ?? 'ops_error'.tr(),
                  style: TextStyle(color: Colors.red),
                ),
                content: Text(state.error),
              ),
            );
          } else if (state is SessionTracksLoadedState ||
              state is SessionCarsLoadedState) {
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
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Tooltip(
                            message: "start_server".tr(),
                            child: Button(
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(material.Icons.start),
                              ),
                              onPressed: () async {
                                if (SelectedServerInherited.of(context)
                                        .selectedServer
                                        .skinLength <
                                    SelectedServerInherited.of(context)
                                        .selectedServer
                                        .clientsAllowed) {
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ContentDialog(
                                        content: Text(
                                          "not_enought_cars".tr(
                                            namedArgs: {
                                              "carNumber":
                                                  SelectedServerInherited.of(
                                                          context)
                                                      .selectedServer
                                                      .clientsAllowed
                                                      .toString()
                                            },
                                          ),
                                        ),
                                        title: Text("cant_run_server".tr()),
                                        actions: [
                                          Button(
                                            child: Text('close'.tr()),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  return;
                                }
                                final Widget widget = ServerRunInstance.run(
                                    (await GetIt.I<SharedManager>()
                                        .getString(SharedKey.acPath))!);
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ContentDialog(
                                      content: widget,
                                      title: Text(
                                          "${SelectedServerInherited.of(context).selectedServer.name} ${"running".tr()}"),
                                      actions: [
                                        Button(
                                          child: Text('close'.tr()),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 24,
                          child: Button(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text('select_server'.tr()),
                            ),
                            onPressed: () {
                              _showSelectServer();
                            },
                          ),
                        ),
                      ],
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
                    title: Text('settings'.tr()),
                  ),
                ],
                items: [
                  PaneItem(
                    icon: const Icon(FluentIcons.server_enviroment),
                    title: Text('server_main_settings'.tr()),
                  ),
                  PaneItem(
                    icon: const Icon(FluentIcons.server_enviroment),
                    title: Text('server_advanced_settings'.tr()),
                  ),
                  PaneItem(
                    icon: StreamBuilder<bool>(
                      stream: GetIt.I<AppearanceBloc>().darkMode,
                      initialData: true,
                      builder: (context, snapshot) {
                        return SvgPicture.asset(
                          SvgPaths.trackSvgPath,
                          width: 24,
                          color: snapshot.data!
                              ? Colors.white
                              : Colors.black.withOpacity(.55),
                        );
                      },
                    ),
                    title: Text('track_selection'.tr()),
                  ),
                  PaneItem(
                    icon: const Icon(FluentIcons.car),
                    title: Text('car_selection'.tr()),
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
    final serverInherited = SelectedServerInherited.of(context);
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ContentDialog(
        title: Text('create_server'.tr()),
        actions: [
          FilledButton(
            child: Text('yes'.tr()),
            onPressed: () {
              create = true;
              Navigator.pop(context);
            },
          ),
          Button(
            child: Text('no'.tr()),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
    if (!create) return;

    final List<int> serverIndexes = GetIt.I<List<Server>>()
        .map(
            (e) => int.parse(e.serverFilesPath.split('/').last.split('_').last))
        .toList();
    //Finds the next available slot for the server
    int currentIndex = 0;
    for (currentIndex; currentIndex < serverIndexes.length; currentIndex++) {
      if (!serverIndexes.contains(currentIndex)) {
        break;
      }
    }
    String serverIndex = currentIndex.toString().length != 2
        ? "0${currentIndex.toString()}"
        : currentIndex.toString();
    final Server server = Server(
        serverFilesPath:
            '${await GetIt.I<SharedManager>().getString(SharedKey.acPath)}/server/presets/SERVER_$serverIndex');
    if (currentIndex >= 4) {
      await Directory(server.serverFilesPath).create();
    }
    GetIt.I<List<Server>>().add(server);
    serverInherited.changeServer(server);
  }

  void _showSelectServer() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ContentDialog(
        title: Text('select_server_edit'.tr()),
        content: ServerSelectorWidget(
          servers: GetIt.I<List<Server>>(),
        ),
        actions: [
          FilledButton(
            child: Text('ok'.tr()),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
