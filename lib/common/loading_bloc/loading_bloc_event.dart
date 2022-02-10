part of 'loading_bloc_bloc.dart';

@immutable
abstract class LoadingBlocEvent {}

class LoadingBlocLoadEvent extends LoadingBlocEvent {
  final BuildContext context;

  LoadingBlocLoadEvent({required this.context});
}

class LoadingBlocShowOnboardingEvent extends LoadingBlocEvent {
  final bool showAppearance;
  final bool showAcPath;

  LoadingBlocShowOnboardingEvent({
    required this.showAcPath,
    required this.showAppearance,
  });
}