import 'dart:io';

import 'package:acservermanager/common/shared_manager.dart';
import 'package:acservermanager/models/enums/shared_key.dart';
import 'package:acservermanager/models/track.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc() : super(SessionInitial()) {
    on<SessionLoadEvent>((event, emit) {
      emit(SessionLoadingState());
    });
    on<SessionLoadTracksEvent>((event, emit) async {
      await _loadTracks(emit);
    });
  }

  Future<void> _loadTracks(Emitter<SessionState> emit) async {
    final trackDir = Directory(
        (await GetIt.I<SharedManager>().getString(SharedKey.acPath))! +
            "/content/tracks");

    List<Track> tracks = [];

    await Future.forEach(trackDir.listSync(), (element) async {
      element as FileSystemEntity;
      final file = File(element.path);
      tracks.add(Track.fromData(await file.readAsLines(), file.path));
    });
    emit(SessionTracksLoadedState(tracks));
  }
}
