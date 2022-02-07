part of 'loading_bloc_bloc.dart';

@immutable
abstract class LoadingBlocState {}

class LoadingBlocInitial extends LoadingBlocState {}

class LoadingBlocLoadingState extends LoadingBlocState {}

class LoadingBlocLoadedState extends LoadingBlocState {
  final List<Server> servers;

  LoadingBlocLoadedState(this.servers);
}