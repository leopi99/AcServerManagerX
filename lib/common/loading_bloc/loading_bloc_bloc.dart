import 'dart:io';

import 'package:acservermanager/common/shared_manager.dart';
import 'package:acservermanager/models/enums/shared_key.dart';
import 'package:acservermanager/models/server.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

part 'loading_bloc_event.dart';
part 'loading_bloc_state.dart';

class LoadingBlocBloc extends Bloc<LoadingBlocEvent, LoadingBlocState> {
  static const String _kConfigPath = "/cfg/server_cfg.ini";

  LoadingBlocBloc() : super(LoadingBlocInitial()) {
    on<LoadingBlocLoadEvent>((event, emit) async {
      await _loadServers(emit);
    });
    on<LoadingBlocAcPathSet>((event, emit) async {
      await _saveAcPath(event.acPath, emit);
    });
  }

  Future<void> _loadServers(Emitter<LoadingBlocState> emit) async {
    emit(LoadingBlocLoadingState());
    final String? acPath =
        await GetIt.instance<SharedManager>().getString(SharedKey.acPath);
    if (acPath == null) {
      emit(LoadingBlocSetAcPathState());
      return;
    }
    File file = File('$acPath$_kConfigPath');
    List<String> data = await file.readAsLines();
    final server = await compute(Server.fromFileData, data);
    //TODO: Load all servers saved, not only the first one
    emit(LoadingBlocLoadedState([server]));
  }

  Future<void> _saveAcPath(
      String acPath, Emitter<LoadingBlocState> emit) async {
    await GetIt.instance<SharedManager>().setString(SharedKey.acPath, acPath);
    await _loadServers(emit);
  }
}
