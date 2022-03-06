import 'package:acservermanager/common/widgets/search_bar.dart';
import 'package:acservermanager/models/track.dart';
import 'package:acservermanager/presentation/skeleton/presentation/bloc/session_bloc.dart';
import 'package:acservermanager/presentation/track_selection_page/presentation/widgets/track_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class TrackSelectionPage extends StatefulWidget {
  const TrackSelectionPage({Key? key}) : super(key: key);

  @override
  State<TrackSelectionPage> createState() => _TrackSelectionPageState();
}

class _TrackSelectionPageState extends State<TrackSelectionPage> {
  SessionBloc? _sessionBloc;
  BehaviorSubject<List<Track>> availableTracks = BehaviorSubject.seeded([]);

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _sessionBloc = BlocProvider.of<SessionBloc>(context);
      _sessionBloc!.add(SessionLoadTracksEvent());
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _sessionBloc ??= BlocProvider.of<SessionBloc>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    debugPrint('Disposing tracks');
    _sessionBloc!.add(SessionUnLoadTracksEvent());
    availableTracks.close();
    super.dispose();
  }

  bool isSelected(int index) {
    return _sessionBloc!.currentSession.selectedTrack ==
        availableTracks.value[index];
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SessionBloc, SessionState>(
      bloc: _sessionBloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is SessionTracksLoadedState) {
          return Stack(
            children: [
              StreamBuilder<List<Track>>(
                  stream: availableTracks,
                  initialData: const [],
                  builder: (context, trackSnapshot) {
                    if (trackSnapshot.data!.isEmpty) {
                      return Center(child: Text("no_track_found".tr()));
                    }
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            MediaQuery.of(context).size.width ~/ 128,
                      ),
                      padding: const EdgeInsets.all(16).copyWith(top: 64),
                      itemBuilder: (context, index) => TrackWidget(
                        track: trackSnapshot.data![index],
                        onSelect: (track) {
                          _sessionBloc!.add(SessionChangeSelectedTrack(track,
                              context: context));
                        },
                        isSelected: isSelected(index),
                        bloc: _sessionBloc!,
                      ),
                      itemCount: trackSnapshot.data!.length,
                    );
                  }),
              SearchBar<Track>(
                searchList: _sessionBloc!.loadedTracks,
                hint: "search_track".tr(),
                onSearch: (tracks) => availableTracks.add(tracks),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
