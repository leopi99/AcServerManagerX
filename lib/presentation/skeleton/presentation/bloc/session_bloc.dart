import 'package:acservermanager/common/helpers/track_helper.dart';
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
    final tracks = await TrackHelper.loadTracks(
      acPath: (await GetIt.I<SharedManager>().getString(SharedKey.acPath))!,
      onError: (error) {
        emit(SessionErrorState(error));
        return;
      },
    );
    loadedTracks = tracks;
    emit(SessionTracksLoadedState());
  }
}
