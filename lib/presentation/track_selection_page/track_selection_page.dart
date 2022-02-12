import 'dart:io';

import 'package:acservermanager/presentation/skeleton/presentation/bloc/session_bloc.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrackSelectionPage extends StatefulWidget {
  const TrackSelectionPage({Key? key}) : super(key: key);

  @override
  State<TrackSelectionPage> createState() => _TrackSelectionPageState();
}

class _TrackSelectionPageState extends State<TrackSelectionPage> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      BlocProvider.of<SessionBloc>(context).add(SessionLoadTracksEvent());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SessionBloc, SessionState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is SessionTracksLoadedState) {
          return GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width ~/ 128,
            children: List.generate(
              state.tracks.length,
              (index) => Image.file(
                File(state.tracks[index].layouts.first.previewImagePath),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
