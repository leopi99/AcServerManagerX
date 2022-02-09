part of 'loading_bloc_bloc.dart';

@immutable
abstract class LoadingBlocEvent {}

class LoadingBlocLoadEvent extends LoadingBlocEvent {
  final BuildContext context;

  LoadingBlocLoadEvent({required this.context});
}

class LoadingBlocSaveEvent extends LoadingBlocEvent {
  final BuildContext context;

  LoadingBlocSaveEvent({required this.context});
}

class LoadingBlocAcPathSet extends LoadingBlocEvent {
  final String acPath;

  final BuildContext context;

  LoadingBlocAcPathSet(
    this.acPath, {
    required this.context,
  });
}

class LoadingBlocAppearanceSet extends LoadingBlocEvent {
  final bool darkMode;

  final BuildContext context;

  LoadingBlocAppearanceSet(
    this.darkMode, {
    required this.context,
  });
}
