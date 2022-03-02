part of 'session_bloc.dart';

@immutable
abstract class SessionEvent {}

// class SessionLoadEvent extends SessionEvent {}

class SessionSaveEvent extends SessionEvent {}

class SessionLoadTracksEvent extends SessionEvent {}

class SessionUnLoadTracksEvent extends SessionEvent {}

class SessionChangeSelectedTrack extends SessionEvent {
  final Track track;
  SessionChangeSelectedTrack(this.track);
}

class SessionLoadCarsEvent extends SessionEvent {}

class SessionUnloadCarsEvent extends SessionEvent {}

class SessionSelectCarEvent extends SessionEvent {
  final Car selectedCar;
  final BuildContext context;

  SessionSelectCarEvent({
    required this.selectedCar,
    required this.context,
  });
}
