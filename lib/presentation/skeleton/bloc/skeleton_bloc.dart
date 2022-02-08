import 'package:rxdart/rxdart.dart';

class SkeletonBloc {
  final BehaviorSubject<int> _currentPageSubject = BehaviorSubject.seeded(0);
  final BehaviorSubject<bool> _panelOpenSubject = BehaviorSubject.seeded(true);

  Stream<int> get currentPage => _currentPageSubject.stream;
  Stream<bool> get panelOpen => _panelOpenSubject.stream;

  void changePage(int index) => _currentPageSubject.add(index);
  void changePaneOpen(bool open) => _panelOpenSubject.add(open);
}
