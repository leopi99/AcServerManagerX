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
