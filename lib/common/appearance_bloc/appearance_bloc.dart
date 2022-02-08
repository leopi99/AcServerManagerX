import 'package:fluent_ui/fluent_ui.dart';
import 'package:rxdart/rxdart.dart';

class AppearanceBloc {
  final BehaviorSubject<bool> _darkModeSubject = BehaviorSubject.seeded(true);
  Stream<bool> get darkMode => _darkModeSubject.stream;

  void setDarkMode({bool? value}) {
    _darkModeSubject.add(value ?? !_darkModeSubject.value);
  }

  Color get backgroundColor => _darkModeSubject.value
      ? const Color.fromARGB(255, 36, 36, 36)
      : Colors.white;
}
