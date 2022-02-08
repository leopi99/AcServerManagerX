part of 'loading_bloc_bloc.dart';

@immutable
abstract class LoadingBlocEvent {}

class LoadingBlocLoadEvent extends LoadingBlocEvent {}

class LoadingBlocSaveEvent extends LoadingBlocEvent {}

class LoadingBlocAcPathSet extends LoadingBlocEvent {
  final String acPath;

  LoadingBlocAcPathSet(this.acPath);
}

class LoadingBlocAppearanceSet extends LoadingBlocEvent {
  final bool darkMode;

  LoadingBlocAppearanceSet(this.darkMode);
}
