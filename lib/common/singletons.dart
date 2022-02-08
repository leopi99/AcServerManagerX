import 'package:acservermanager/common/shared_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Singletons {
  static Future<void> initSingletons() async {
    //Registers the shared manager
    await SharedPreferences.getInstance().then((value) {
      // value.clear();
      GetIt.instance.registerSingleton<SharedManager>(SharedManager(value));
    });
  }
}
