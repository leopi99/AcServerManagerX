import 'dart:io';

import 'package:acservermanager/common/helpers/car_helper.dart';
import 'package:acservermanager/common/helpers/track_helper.dart';
import 'package:acservermanager/common/inherited_widgets/selected_server_inherited.dart';
import 'package:acservermanager/common/logger.dart';
import 'package:acservermanager/common/shared_manager.dart';
import 'package:acservermanager/models/car.dart';
import 'package:acservermanager/models/enums/shared_key.dart';
import 'package:acservermanager/models/server.dart';
import 'package:acservermanager/models/session.dart';
import 'package:acservermanager/models/track.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          message: "${Platform.environment} is not yet supported."));
    }
    on<LoadingBlocLoadEvent>((event, emit) async {
      final serverInherited = SelectedServerInherited.of(event.context);
      await Logger().initialized;
      final darkMode =
          GetIt.instance<SharedManager>().getBool(SharedKey.appearance);
      final acPath =
          await GetIt.instance<SharedManager>().getString(SharedKey.acPath);
      if (darkMode == null || acPath == null) {
        add(LoadingBlocShowOnboardingEvent(
            showAcPath: acPath == null, showAppearance: darkMode == null));
        return;
      }
      await _loadServers(emit, serverInherited);
    });
    on<LoadingBlocShowOnboardingEvent>((event, emit) {
      emit(LoadingBlocShowOnboardingState(
          showAcPath: event.showAcPath, showAppearance: event.showAppearance));
    });
  }

  Future<void> _loadServers(Emitter<LoadingBlocState> emit,
      SelectedServerInherited serverInherited) async {
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
      Logger().log('Servers found: ${serverNames.toString()}', name: "loading_bloc");
    } catch (e, stacktrace) {
      _emitError(e.toString(), emit, stackTrace: stacktrace.toString());
      return;
    }
    List<Server> servers = [];
    List<Map<String, String>> trackNames = [];
    //Loads the servers found in the previous step
    try {
      servers = List.generate(
        files.length,
        (index) {
          final List<String> fileData = files[index].readAsLinesSync();
          trackNames.add({
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
      _emitError(e.toString(), emit, stackTrace: stacktrace.toString());
      return;
    }
    //Loads the selected track for each server
    await _getTracksSetTrack(
      acPath: acPath,
      servers: servers,
      trackNames: trackNames,
      onError: (e) => _emitError(e, emit),
    );
    int index = 0;
    //Loads the selected cars for each server
    try {
      await Future.forEach<Server>(
        servers,
        (element) async {
          servers[index] = await _getCarsSetCars(
            server: element,
            onError: (e) => _emitError(e, emit),
            acPath: acPath,
            carNames: await element.getSavedCars(),
          );
          index++;
        },
      );
    } catch (e, stacktrace) {
      _emitError(e.toString(), emit, stackTrace: stacktrace.toString());
    }
    GetIt.instance.registerSingleton(servers);
    serverInherited.changeServer(servers.first, false);
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
    int index = 0;
    await Future.forEach<Map<String, String>>(trackNames, (trackName) async {
      Track? track = await TrackHelper.loadTrackFrom(
          "$acPath/content/tracks/${trackName['name']}");
      if (track == null) return;
      servers[index] = servers[index].copyWith(
        session: Session(
          selectedTrack: track.copyWith(
            layouts: [
              track.layouts.firstWhere(
                (element) => element.path.toLowerCase().contains(
                      trackName['layout']!.toLowerCase(),
                    ),
              )
            ],
          ),
        ),
      );
      index++;
    });
  }

  ///Assignes to the servers the selected [Car]s from the [carNames] list.
  ///
  ///The [carNames] list is the list of the names of the cars inside the server entry_list file, arranged like this:
  ///
  ///[{"CarName": "CarSkinName1, CarSkinName2"}...]
  Future<Server> _getCarsSetCars({
    required Server server,
    required Function(String) onError,
    required String acPath,
    required List<Map<String, String>> carNames,
  }) async {
    await Future.forEach<Map<String, String>>(
      carNames,
      (element) async {
        Car? car = await CarHelper.loadCarFrom(
            "$acPath/content/cars/${element.keys.first}");
        if (car == null) {
          Logger().log(
              "No car found with the path: ${acPath + element.keys.first}",
              name: "_getCarsSetCars ${server.name}");
          return server;
        }
        car = car.copyWith(
          skins: car.skins
              .where(
                (skin) => element.values.first
                    .split(',')
                    .contains(skin.path.split('/').last),
              )
              .toList(),
        );
        final serverCars = [...server.cars, car];
        server = server.copyWith(cars: serverCars);
      },
    );
    return server;
  }

  void _emitError(String error, Emitter<LoadingBlocState> emit,
      {String? stackTrace}) {
    emit(LoadingBlocErrorState("An error accoured, please try again.\n$error"));
    debugPrint("Error: $error\nStacktrace:\n$stackTrace");
  }
}
