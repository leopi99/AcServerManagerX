import 'dart:io';

import 'package:acservermanager/models/track.dart';
import 'package:fluent_ui/fluent_ui.dart';

class TrackWidget extends StatelessWidget {
  final Track track;
  const TrackWidget({
    Key? key,
    required this.track,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(track.layouts.first.previewImagePath),
    );
  }
}
