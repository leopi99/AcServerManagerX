import 'package:acservermanager/common/appearance_bloc/appearance_bloc.dart';
import 'package:acservermanager/common/shared_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Singletons {
  static Future<void> initSingletons() async {
    //Registers the shared manager
    try {
      await SharedPreferences.getInstance().then((value) {
        // value.clear();
        GetIt.I.registerSingleton<SharedManager>(SharedManager(value));
      });
      GetIt.I.registerLazySingleton<AppearanceBloc>(() => AppearanceBloc());
    } catch (e) {
      debugPrint('Unable to register Singletons using GetIt:\n$e');
    }
  }
}
