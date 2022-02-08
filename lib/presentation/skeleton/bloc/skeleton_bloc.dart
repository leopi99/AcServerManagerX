import 'package:rxdart/rxdart.dart';

class SkeletonBloc {
  final BehaviorSubject<int> _currentPageSubject = BehaviorSubject.seeded(0);

  Stream<int> get currentPage => _currentPageSubject.stream;

  void changePage(int index) => _currentPageSubject.add(index);
  int get currentPageSync => _currentPageSubject.value;
}
