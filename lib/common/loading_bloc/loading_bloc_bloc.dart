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
    debugPrint('AcPath: $acPath');
    List<File> files = [];
    List<String> serverNames = [];
    final String presetsPath = acPath + '/server/presets';
    //Searched for already configured servers
    try {
      Directory(presetsPath).listSync().forEach((element) {
        Directory dir = Directory(element.path);
        if (dir.listSync().length == 2) {
          serverNames.add(dir.path.split('\\').last);
        }
      });
      for (String name in serverNames) {
        files.add(File('$presetsPath/$name/server_cfg.ini'));
      }
      debugPrint('Servers: ${serverNames.toString()}');
    } catch (e, stacktrace) {
      debugPrint("Error: $e\nStacktrace:\n$stacktrace");
      emit(LoadingBlocErrorState("An error accoured, please try again.\n$e"));
      return;
    }
    List<Server> servers = [];
    //Loads the servers found in the previous step
    try {
      servers = List.generate(
        files.length,
        (index) => Server.fromFileData(files[index].readAsLinesSync(),
            '$presetsPath/${serverNames[index]}'),
      );
      if (servers.isEmpty) {
        servers.add(Server(serverFilesPath: '$presetsPath/SERVER_00'));
      }
    } catch (e, stacktrace) {
      debugPrint("Error: $e\nStacktrace:\n$stacktrace");
      emit(LoadingBlocErrorState("An error accoured, please try again.\n$e"));
      return;
    }
    GetIt.instance.registerSingleton(servers);
    SelectedServerInherited.of(context).changeServer(servers.first);
    emit(LoadingBlocLoadedState(servers));
  }
}
