part of 'session_bloc.dart';

@immutable
abstract class SessionEvent {}

class SessionLoadEvent extends SessionEvent {}

class SessionSaveEvent extends SessionEvent {}

class SessionLoadTracksEvent extends SessionLoadEvent {}

class SessionUnLoadTracksEvent extends SessionLoadEvent {}
