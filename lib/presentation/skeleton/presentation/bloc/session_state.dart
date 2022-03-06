part of 'session_bloc.dart';

@immutable
abstract class SessionState {}

class SessionInitial extends SessionState {}

class SessionLoadingState extends SessionState {}

class SessionTracksLoadedState extends SessionState {}

class SessionCarsLoadedState extends SessionState {}

class SessionErrorState extends SessionState {
  final String error;
  final bool isCritic;
  final String? message;

  SessionErrorState(this.error, {this.isCritic = true, this.message});
}
