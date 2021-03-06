part of 'loading_bloc_bloc.dart';

@immutable
abstract class LoadingBlocState {}

class LoadingBlocInitial extends LoadingBlocState {}

class LoadingBlocLoadingState extends LoadingBlocState {}

class LoadingBlocLoadedState extends LoadingBlocState {
  final List<Server> servers;

  LoadingBlocLoadedState(this.servers);
}

class LoadingBlocErrorState extends LoadingBlocState {
  final String error;

  LoadingBlocErrorState(this.error);
}

class LoadingBlocShowOnboardingState extends LoadingBlocState {
  final bool showAppearance;
  final bool showAcPath;

  LoadingBlocShowOnboardingState({
    required this.showAcPath,
    required this.showAppearance,
  });
}
