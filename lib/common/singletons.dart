import 'package:acservermanager/common/appearance_bloc/appearance_bloc.dart';
import 'package:acservermanager/common/logger.dart';
import 'package:acservermanager/common/shared_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Singletons {
  static Future<void> initSingletons() async {
    //Registers the shared manager
    try {
      await SharedPreferences.getInstance().then((value) {
        //Uncomment this to clear the shared preferences
        // value.clear();
        GetIt.I.registerSingleton<SharedManager>(SharedManager(value));
      });
      GetIt.I.registerLazySingleton<AppearanceBloc>(() => AppearanceBloc());
    } catch (e) {
      Logger().log('Unable to register Singletons using GetIt:\n$e',
          name: "Singletons.initSingletons");
    }
  }
}
