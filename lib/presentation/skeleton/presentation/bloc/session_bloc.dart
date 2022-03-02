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
  List<Track> loadedTracks = [];
  List<Car> loadedCars = [];

  Session get currentSession => _currentSession;

  SessionBloc() : super(SessionInitial()) {
    on<SessionLoadTracksEvent>((event, emit) async {
      await _loadTracks(emit);
    });
    on<SessionUnLoadTracksEvent>((event, emit) {
      loadedTracks.clear();
      debugPrint('Removed the tracks');
      emit(SessionInitial());
    });
    on<SessionChangeSelectedTrack>((event, emit) {
      _currentSession = _currentSession.copyWith(selectedTrack: event.track);
      emit(SessionTracksLoadedState());
    });
    on<SessionLoadCarsEvent>((event, emit) async {
      await _loadCars(emit);
    });
    on<SessionUnloadCarsEvent>((event, emit) {
      loadedCars.clear();
      debugPrint('Removed the cars');
      emit(SessionInitial());
    });
    on<SessionSelectCarEvent>((event, emit) {
      _selectCar(emit, event);
    });
  }

  Future<void> _loadTracks(Emitter<SessionState> emit) async {
    emit(SessionLoadingState());
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

  Future<void> _loadCars(Emitter<SessionState> emit) async {
    emit(SessionLoadingState());
    final cars = await CarHelper.loadCars(
      acPath: (await GetIt.I<SharedManager>().getString(SharedKey.acPath))!,
      onError: (error) {
        emit(SessionErrorState(error));
        return;
      },
    );
    loadedCars = cars;
    debugPrint("Cars loaded");
    emit(SessionCarsLoadedState());
  }

  void _selectCar(Emitter<SessionState> emit, SessionSelectCarEvent event) {
    final serverInherited = SelectedServerInherited.of(event.context);
    List<Car> cars = serverInherited.selectedServer.cars;
    cars.add(event.selectedCar);
    //Updates the server
    serverInherited.changeServer(
      serverInherited.selectedServer.copyWith(cars: cars),
    );
  }
}
