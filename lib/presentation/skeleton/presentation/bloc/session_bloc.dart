import 'dart:io';

import 'package:acservermanager/common/shared_manager.dart';
import 'package:acservermanager/models/enums/shared_key.dart';
import 'package:acservermanager/models/session.dart';
import 'package:acservermanager/models/track.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  static const String _kTracksPath = "/content/tracks";
  Session _currentSession = const Session();
  List<Track> loadedTracks = [];

  Session get currentSession => _currentSession;

  SessionBloc() : super(SessionInitial()) {
    on<SessionLoadTracksEvent>((event, emit) async {
      await _loadTracks(emit);
    });
    on<SessionUnLoadTracksEvent>((event, emit) {
      debugPrint('Removed the tracks');
      loadedTracks = [];
      emit(SessionInitial());
    });
    on<SessionChangeSelectedTrack>((event, emit) {
      _currentSession = _currentSession.copyWith(selectedTrack: event.track);
      emit(SessionTracksLoadedState());
    });
  }

  Future<void> _loadTracks(Emitter<SessionState> emit) async {
    final trackDir = Directory(
        (await GetIt.I<SharedManager>().getString(SharedKey.acPath))! +
            _kTracksPath);

    List<Track> tracks = [];

    int index = 0;

    try {
      await Future.forEach(trackDir.listSync(), (element) async {
        element as FileSystemEntity;
        final dir = Directory(element.path);
        tracks.add(await Track.fromData(dir, index));
        index++;
      });
    } catch (e, stacktrace) {
      debugPrint('Error: $e\nStackTrace:\n$stacktrace');
      //TODO: Uncomment when ready
      // emit(SessionErrorState(e.toString()));
      // return;
    }
    loadedTracks = tracks;
    emit(SessionTracksLoadedState());
  }
}
