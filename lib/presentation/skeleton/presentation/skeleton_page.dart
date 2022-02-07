import 'package:acservermanager/presentation/homepage/homepage.dart';
import 'package:acservermanager/presentation/skeleton/bloc/skeleton_bloc.dart';
import 'package:fluent_ui/fluent_ui.dart';

class SkeletonPage extends StatelessWidget {
  SkeletonPage({Key? key}) : super(key: key);

  final SkeletonBloc _bloc = SkeletonBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _bloc.currentPage,
      initialData: 0,
      builder: (context, snapshot) {
        return TabView(
          currentIndex: snapshot.data!,
          tabs: const [
            Tab(text: Text('Homepage')),
          ],
          bodies: const [
            Homepage(),
          ],
        );
      },
    );
  }
}
