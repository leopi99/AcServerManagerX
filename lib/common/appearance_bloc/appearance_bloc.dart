import 'package:rxdart/rxdart.dart';

class AppearanceBloc {
  final BehaviorSubject<bool> _darkModeSubject = BehaviorSubject.seeded(true);
  Stream<bool> get darkMode => _darkModeSubject.stream;

  void setDarkMode({bool? value}) {
    _darkModeSubject.add(value ?? !_darkModeSubject.value);
  }
}
