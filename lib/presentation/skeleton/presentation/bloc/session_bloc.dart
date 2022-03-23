import 'dart:collection';

import 'package:acservermanager/common/helpers/car_helper.dart';
import 'package:acservermanager/common/helpers/track_helper.dart';
import 'package:acservermanager/common/inherited_widgets/selected_server_inherited.dart';
import 'package:acservermanager/common/shared_manager.dart';
import 'package:acservermanager/models/car.dart';
import 'package:acservermanager/models/enums/shared_key.dart';
import 'package:acservermanager/models/session.dart';
import 'package:acservermanager/models/track.dart';
import 'package:bloc/bloc.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get_it/get_it.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  Session _currentSession = const Session();
  List<Track> _loadedTracks = [];
  List<Car> _loadedCars = [];
  UnmodifiableListView<Track> get loadedTracks =>
      UnmodifiableListView(_loadedTracks);
  UnmodifiableListView<Car> get loadedCars => UnmodifiableListView(_loadedCars);
  Session get currentSession => _currentSession;

  SessionBloc() : super(SessionInitial()) {
    on<SessionLoadTracksEvent>((event, emit) async => await _loadTracks(emit));
    on<SessionUnLoadTracksEvent>((event, emit) => _unloadTracks(emit));
    on<SessionChangeSelectedTrack>(
        (event, emit) => _changeSelectedTrack(emit, event));
    on<SessionLoadCarsEvent>((event, emit) async => await _loadCars(emit));
    on<SessionUnloadCarsEvent>((event, emit) => _unloadCars(emit));
    on<SessionSelectCarEvent>((event, emit) => _selectCar(emit, event));
    on<SessionUnselectTrackEvent>((event, emit) => _unselectTrack(emit, event));
    on<SessionChangeSessionEvent>(
        (event, emit) => _changeCurrentSession(emit, event));
  }

  ///Loads all the tracks available
  Future<void> _loadTracks(Emitter<SessionState> emit) async {
    emit(SessionLoadingState());
    final tracks = await TrackHelper.loadTracks(
      acPath: (await GetIt.I<SharedManager>().getString(SharedKey.acPath))!,
      onError: (error) {
        emit(SessionErrorState(error));
        return;
      },
    );
    _loadedTracks = tracks;
    emit(SessionTracksLoadedState());
  }

  ///Loads all the cars available
  Future<void> _loadCars(Emitter<SessionState> emit) async {
    emit(SessionLoadingState());
    final cars = await CarHelper.loadCars(
      acPath: (await GetIt.I<SharedManager>().getString(SharedKey.acPath))!,
      onError: (error) {
        emit(SessionErrorState(error));
        return;
      },
    );
    _loadedCars = cars;
    emit(SessionCarsLoadedState());
  }

  ///Adds a car to the current session
  void _selectCar(Emitter<SessionState> emit, SessionSelectCarEvent event) {
    final serverInherited = SelectedServerInherited.of(event.context);
    List<Car> cars = serverInherited.selectedServer.cars;
    cars.add(event.selectedCar);
    serverInherited.changeServer(
      serverInherited.selectedServer.copyWith(cars: cars),
    );
  }

  ///Unloads the loaded cars
  void _unloadCars(Emitter<SessionState> emit) {
    _loadedCars.clear();
    emit(SessionInitial());
  }

  ///Unloads the loaded tracks
  void _unloadTracks(Emitter<SessionState> emit) {
    _loadedTracks.clear();
    emit(SessionInitial());
  }

  ///Changes the selected track
  void _changeSelectedTrack(
      Emitter<SessionState> emit, SessionChangeSelectedTrack event) {
    _currentSession = _currentSession.copyWith(selectedTrack: event.track);
    SelectedServerInherited.of(event.context).changeServer(
      SelectedServerInherited.of(event.context)
          .selectedServer
          .copyWith(session: _currentSession),
    );
    emit(SessionTracksLoadedState());
  }

  ///Unselects the previously selected track
  void _unselectTrack(
      Emitter<SessionState> emit, SessionUnselectTrackEvent event) {
    _currentSession = _currentSession.copyWith(selectedTrack: null);
    SelectedServerInherited.of(event.context).changeServer(
      SelectedServerInherited.of(event.context)
          .selectedServer
          .copyWith(session: _currentSession),
    );
    emit(SessionTracksLoadedState());
  }

  void _changeCurrentSession(
      Emitter<SessionState> emit, SessionChangeSessionEvent event) {
    _currentSession = event.session;
    emit(state);
  }
}
