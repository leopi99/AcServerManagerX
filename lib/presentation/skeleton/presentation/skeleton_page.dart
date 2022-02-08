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
        return NavigationView(
          content: NavigationBody(
            index: snapshot.data!,
            children: const [
              Homepage(),
              Homepage(),
            ],
          ),
          pane: NavigationPane(
            onChanged: (index) {
              _bloc.changePage(index);
            },
            selected: snapshot.data!,
            items: [
              PaneItem(
                icon: const Icon(FluentIcons.home),
                title: const Text('Home'),
              ),
              PaneItem(
                icon: const Icon(FluentIcons.home),
                title: const Text('Home'),
              ),
            ],
          ),
        );
      },
    );
  }
}
