part of 'session_bloc.dart';

@immutable
abstract class SessionEvent {}

// class SessionLoadEvent extends SessionEvent {}

class SessionSaveEvent extends SessionEvent {}

class SessionLoadTracksEvent extends SessionEvent {}

class SessionUnLoadTracksEvent extends SessionEvent {}

class SessionChangeSelectedTrack extends SessionEvent {
  final Track track;
  final BuildContext context;
  SessionChangeSelectedTrack(this.track, {required this.context});
}

class SessionUnselectTrackEvent extends SessionEvent {
  final BuildContext context;

  SessionUnselectTrackEvent(this.context);
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
