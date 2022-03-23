import 'dart:io';

import 'package:acservermanager/common/helpers/track_helper.dart';
import 'package:acservermanager/common/inherited_widgets/selected_server_inherited.dart';
import 'package:acservermanager/common/logger.dart';
import 'package:acservermanager/common/shared_manager.dart';
import 'package:acservermanager/models/enums/shared_key.dart';
import 'package:acservermanager/models/server.dart';
import 'package:acservermanager/models/session.dart';
import 'package:bloc/bloc.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

part 'loading_bloc_event.dart';
part 'loading_bloc_state.dart';

class LoadingBlocBloc extends Bloc<LoadingBlocEvent, LoadingBlocState> {
  static const String _kServerConfig = "/server_cfg.ini";
  static const String _kPresetsPath = "/server/presets";

  LoadingBlocBloc() : super(LoadingBlocInitial()) {
    if (!Platform.isWindows) {
      throw (PlatformException(
          code: "platform_not_supported",
          message: "${Platform.environment} is not supported."));
    }
    on<LoadingBlocLoadEvent>((event, emit) async {
      final darkMode =
          GetIt.instance<SharedManager>().getBool(SharedKey.appearance);
      final acPath =
          await GetIt.instance<SharedManager>().getString(SharedKey.acPath);
      if (darkMode == null || acPath == null) {
        add(LoadingBlocShowOnboardingEvent(
            showAcPath: acPath == null, showAppearance: darkMode == null));
        return;
      }
      await _loadServers(emit, event.context);
    });
    on<LoadingBlocShowOnboardingEvent>((event, emit) {
      emit(LoadingBlocShowOnboardingState(
          showAcPath: event.showAcPath, showAppearance: event.showAppearance));
    });
  }

  Future<void> _loadServers(
      Emitter<LoadingBlocState> emit, BuildContext context) async {
    emit(LoadingBlocLoadingState());
    final String acPath =
        (await GetIt.instance<SharedManager>().getString(SharedKey.acPath))!;
    List<File> files = [];
    List<String> serverNames = [];
    final String presetsPath = acPath + _kPresetsPath;
    //Searches for already configured servers
    try {
      Directory(presetsPath).listSync().forEach((element) {
        Directory dir = Directory(element.path);
        if (dir.listSync().length == 2) {
          serverNames.add(dir.path.split('\\').last);
        }
      });
      //Adds the config files of the servers that are already configured
      for (String name in serverNames) {
        files.add(File('$presetsPath/$name/$_kServerConfig'));
      }
      Logger().log('Servers: ${serverNames.toString()}');
    } catch (e, stacktrace) {
      Logger().log("Error: $e\nStacktrace:\n$stacktrace");
      emit(LoadingBlocErrorState("An error accoured, please try again.\n$e"));
      return;
    }
    List<Server> servers = [];
    List<Map<String, String>> _trackNames = [];
    //Loads the servers found in the previous step
    try {
      servers = List.generate(
        files.length,
        (index) {
          final List<String> fileData = files[index].readAsLinesSync();
          _trackNames.add({
            "name": Server.getStringFromData(fileData, "TRACK"),
            "layout": Server.getStringFromData(fileData, "CONFIG_TRACK"),
          });
          return Server.fromFileData(
              fileData, '$presetsPath/${serverNames[index]}');
        },
      );
      if (servers.isEmpty) {
        servers.add(Server(serverFilesPath: '$presetsPath/SERVER_00'));
      }
    } catch (e, stacktrace) {
      Logger().log("Error: $e\nStacktrace:\n$stacktrace");
      emit(LoadingBlocErrorState("An error accoured, please try again.\n$e"));
      return;
    }
    await _getTracksSetTrack(
      acPath: acPath,
      servers: servers,
      trackNames: _trackNames,
      onError: (e) {
        emit(LoadingBlocErrorState("An error accoured, please try again.\n$e"));
      },
    );
    Logger().log(servers.first.session.selectedTrack?.name ?? "none");
    GetIt.instance.registerSingleton(servers);
    SelectedServerInherited.of(context).changeServer(servers.first);
    emit(LoadingBlocLoadedState(servers));
    await close();
  }

  ///Assignes to the servers the selected [Track] from the [trackNames] list.
  ///
  ///The [trackNames] list is the list of the names of the tracks inside the server config file.
  ///
  ///The [trackNames] must be the same length as the [servers] list and in the correct order.
  Future<void> _getTracksSetTrack({
    required List<Server> servers,
    required Function(String) onError,
    required String acPath,
    required List<Map<String, String>> trackNames,
  }) async {
    assert(servers.length == trackNames.length);
    final tracks =
        await TrackHelper.loadTracks(acPath: acPath, onError: onError);
    for (int i = 0; i < servers.length; i++) {
      if (tracks.any((element) => element.path
          .toLowerCase()
          .contains(trackNames[i]['name']!.toLowerCase()))) {
        final track = tracks.firstWhere((element) => element.path
            .toLowerCase()
            .contains(trackNames[i]['name']!.toLowerCase()));
        servers[i] = servers[i].copyWith(
          session: Session(
            selectedTrack: track.copyWith(
              layouts: track.layouts.length > 1
                  ? [
                      track.layouts.firstWhere((element) => element.path
                          .toLowerCase()
                          .contains(trackNames[i]['layout']!.toLowerCase()))
                    ]
                  : track.layouts,
            ),
          ),
        );
      }
    }
  }
}
