part of 'loading_bloc_bloc.dart';

@immutable
abstract class LoadingBlocEvent {}

class LoadingBlocLoadEvent extends LoadingBlocEvent {}

class LoadingBlocSaveEvent extends LoadingBlocEvent {}
