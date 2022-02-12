part of 'session_bloc.dart';

@immutable
abstract class SessionState {}

class SessionInitial extends SessionState {}

class SessionLoadingState extends SessionState {}

class SessionTracksLoadedState extends SessionState {
  final List<Track> tracks;

  SessionTracksLoadedState(this.tracks);
}

class SessionErrorState extends SessionState {
  final String error;

  SessionErrorState(this.error);
}
