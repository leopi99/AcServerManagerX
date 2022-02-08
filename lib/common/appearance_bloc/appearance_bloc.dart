import 'package:acservermanager/common/shared_manager.dart';
import 'package:acservermanager/models/enums/shared_key.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class AppearanceBloc {
  final BehaviorSubject<bool> _darkModeSubject = BehaviorSubject.seeded(true);
  Stream<bool> get darkMode => _darkModeSubject.stream;

  AppearanceBloc() {
    final darkMode = GetIt.I<SharedManager>().getBool(SharedKey.appearance);
    if (darkMode != null) {
      _darkModeSubject.add(darkMode);
    }
  }

  void setDarkMode({bool? value}) {
    _darkModeSubject.add(value ?? !_darkModeSubject.value);
    GetIt.I<SharedManager>()
        .setBool(SharedKey.appearance, _darkModeSubject.value);
  }

  Color get backgroundColor => _darkModeSubject.value
      ? const Color.fromARGB(255, 36, 36, 36)
      : Colors.white;
}
