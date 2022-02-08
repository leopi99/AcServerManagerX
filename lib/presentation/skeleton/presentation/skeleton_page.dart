import 'package:acservermanager/presentation/homepage/homepage.dart';
import 'package:acservermanager/presentation/skeleton/bloc/skeleton_bloc.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;

class SkeletonPage extends StatelessWidget {
  SkeletonPage({Key? key}) : super(key: key);

  final SkeletonBloc _bloc = SkeletonBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _bloc.currentPage,
      initialData: 0,
      builder: (context, snapshot) {
        return StreamBuilder<bool>(
          stream: _bloc.panelOpen,
          initialData: true,
          builder: (context, panelOpenSnapshot) {
            return NavigationView(
              content: NavigationBody(
                index: snapshot.data!,
                children: const [
                  Homepage(),
                  Homepage(),
                ],
              ),
              pane: NavigationPane(
                onChanged: _bloc.changePage,
                menuButton: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: panelOpenSnapshot.data!
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(material.Icons.menu),
                        onPressed: () {
                          _bloc.changePaneOpen(!panelOpenSnapshot.data!);
                        },
                      ),
                    ],
                  ),
                ),
                displayMode: panelOpenSnapshot.data!
                    ? PaneDisplayMode.open
                    : PaneDisplayMode.compact,
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
      },
    );
  }
}
