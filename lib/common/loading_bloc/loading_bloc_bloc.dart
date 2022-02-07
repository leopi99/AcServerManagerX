import 'package:acservermanager/models/server.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'loading_bloc_event.dart';
part 'loading_bloc_state.dart';

class LoadingBlocBloc extends Bloc<LoadingBlocEvent, LoadingBlocState> {
  LoadingBlocBloc() : super(LoadingBlocInitial()) {
    on<LoadingBlocLoadEvent>((event, emit) async {
      await _loadServers(emit);
    });
  }

  Future<void> _loadServers(Emitter<LoadingBlocState> emit) async {
    emit(LoadingBlocLoadingState());
    await Future.delayed(const Duration(seconds: 1));
  }
}
