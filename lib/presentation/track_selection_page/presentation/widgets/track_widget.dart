import 'dart:io';

import 'package:acservermanager/models/track.dart';
import 'package:acservermanager/presentation/skeleton/presentation/bloc/session_bloc.dart';
import 'package:acservermanager/presentation/track_selection_page/presentation/widgets/track_bottom_sheet.dart';
import 'package:fluent_ui/fluent_ui.dart';

class TrackWidget extends StatelessWidget {
  final Track track;
  final Function(Track) onSelect;
  final bool isSelected;
  final SessionBloc bloc;

  const TrackWidget({
    Key? key,
    required this.track,
    required this.onSelect,
    required this.bloc,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widget = GestureDetector(
      onTap: () {
        if (track.layouts.length == 1) {
          onSelect(track);
        } else {
          showBottomSheet(
            enableDrag: false,
            shape: const ContinuousRectangleBorder(),
            context: context,
            builder: (context) => TrackBottomSheetWidget(
                track: track, onSelect: onSelect, bloc: bloc),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Image.file(
              File(track.layouts.first.previewImagePath),
            ),
            Text(track.circuitName),
          ],
        ),
      ),
    );
    return track.info != null
        ? Tooltip(
            message: track.info!.description,
            child: widget,
          )
        : widget;
  }
}
