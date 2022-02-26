import 'package:acservermanager/presentation/skeleton/presentation/bloc/session_bloc.dart';
import 'package:acservermanager/presentation/track_selection_page/presentation/widgets/track_widget.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrackSelectionPage extends StatefulWidget {
  const TrackSelectionPage({Key? key}) : super(key: key);

  @override
  State<TrackSelectionPage> createState() => _TrackSelectionPageState();
}

class _TrackSelectionPageState extends State<TrackSelectionPage> {
  SessionBloc? _sessionBloc;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _sessionBloc = BlocProvider.of<SessionBloc>(context);
      _sessionBloc!.add(SessionLoadTracksEvent());
    });
    super.initState();
  }

  @override
  void dispose() {
    debugPrint('Disposing tracks');
    _sessionBloc!.add(SessionUnLoadTracksEvent());
    super.dispose();
  }

  bool isSelected(int index) {
    return _sessionBloc!.currentSession.selectedTrack ==
        _sessionBloc!.loadedTracks[index];
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SessionBloc, SessionState>(
      bloc: _sessionBloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is SessionTracksLoadedState) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width ~/ 128,
              mainAxisExtent: 190,
            ),
            itemBuilder: (context, index) => TrackWidget(
              track: _sessionBloc!.loadedTracks[index],
              onSelect: (track) {
                _sessionBloc!.add(SessionChangeSelectedTrack(track));
              },
              isSelected: isSelected(index),
            ),
            itemCount: _sessionBloc!.loadedTracks.length,
          );
        }
        return Container();
      },
    );
  }
}
