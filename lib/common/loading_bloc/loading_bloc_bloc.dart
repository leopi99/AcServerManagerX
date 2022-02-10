import 'dart:io';

import 'package:acservermanager/common/inherited_widgets/selected_server_inherited.dart';
import 'package:acservermanager/common/shared_manager.dart';
import 'package:acservermanager/models/enums/shared_key.dart';
import 'package:acservermanager/models/server.dart';
import 'package:bloc/bloc.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get_it/get_it.dart';

part 'loading_bloc_event.dart';
part 'loading_bloc_state.dart';

class LoadingBlocBloc extends Bloc<LoadingBlocEvent, LoadingBlocState> {
  LoadingBlocBloc() : super(LoadingBlocInitial()) {
    on<LoadingBlocLoadEvent>((event, emit) async {
      await _loadServers(emit, event.context);
    });
    on<LoadingBlocAcPathSet>((event, emit) async {
      await _saveAcPath(event.acPath, emit, event.context);
    });
    on<LoadingBlocAppearanceSet>((event, emit) async {
      await _saveAppearance(event.darkMode, emit, event.context);
    });
  }

  Future<void> _loadServers(
      Emitter<LoadingBlocState> emit, BuildContext context) async {
    emit(LoadingBlocLoadingState());
    final String? acPath =
        await GetIt.instance<SharedManager>().getString(SharedKey.acPath);
    debugPrint('acPath: $acPath');
    if (acPath == null) {
      emit(LoadingBlocSetAcPathState());
      return;
    }
    final darkMode =
        GetIt.instance<SharedManager>().getBool(SharedKey.appearance);
    debugPrint('darkMode: $darkMode');
    if (darkMode == null) {
      emit(LoadingBlocSetAppAppearanceState());
      return;
    }
    List<File> files = [];
    List<String> serverNames = [];
    try {
      Directory(acPath + '/presets').listSync().forEach((element) {
        Directory dir = Directory(element.path);
        if (dir.listSync().length == 2) {
          serverNames.add(dir.path.split('\\').last);
        }
      });
      for (String name in serverNames) {
        files.add(File('$acPath/presets/$name/server_cfg.ini'));
      }
      debugPrint('Servers: ${serverNames.toString()}');
    } catch (e, stacktrace) {
      debugPrint("Error: $e\nStacktrace:\n$stacktrace");
      emit(LoadingBlocErrorState("An error accoured, please try again.\n$e"));
      return;
    }
    List<Server> server = [];

    try {
      server = List.generate(
        files.length,
        (index) => Server.fromFileData(files[index].readAsLinesSync(),
            '$acPath/presets/${serverNames[index]}'),
      );
      if (server.isEmpty) {
        server.add(Server(serverFilesPath: '$acPath/presets/SERVER_00'));
      }
    } catch (e, stacktrace) {
      debugPrint("Error: $e\nStacktrace:\n$stacktrace");
      emit(LoadingBlocErrorState("An error accoured, please try again.\n$e"));
      return;
    }
    GetIt.instance.registerSingleton(server);
    SelectedServerInherited.of(context).changeServer(server.first);
    emit(LoadingBlocLoadedState(server));
  }

  Future<void> _saveAcPath(String acPath, Emitter<LoadingBlocState> emit,
      BuildContext context) async {
    acPath += "/server";
    await GetIt.instance<SharedManager>().setString(SharedKey.acPath, acPath);
    await _loadServers(emit, context);
  }

  Future<void> _saveAppearance(bool darkMode, Emitter<LoadingBlocState> emit,
      BuildContext context) async {
    final bool? loadServers =
        GetIt.instance<SharedManager>().getBool(SharedKey.appearance);
    await GetIt.instance<SharedManager>()
        .setBool(SharedKey.appearance, darkMode);
    if (loadServers == null) {
      await _loadServers(emit, context);
    }
  }
}
