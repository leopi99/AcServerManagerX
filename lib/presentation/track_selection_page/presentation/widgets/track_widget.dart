import 'dart:io';

import 'package:acservermanager/models/track.dart';
import 'package:fluent_ui/fluent_ui.dart';

class TrackWidget extends StatelessWidget {
  final Track track;
  final Function(Track) onSelect;
  final bool isSelected;
  const TrackWidget({
    Key? key,
    required this.track,
    required this.onSelect,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelect(track);
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
  }
}
