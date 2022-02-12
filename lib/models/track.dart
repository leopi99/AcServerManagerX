import 'dart:convert';
import 'dart:io';

import 'package:acservermanager/models/layout.dart';

class Track {
  static const String kUiDirPath = "/ui";
  static const String kPreviewPath = '$kUiDirPath/preview.png';
  static const String kUiTrackInfo = '$kUiDirPath/ui_track.json';

  final String name;
  final String circuitName;

  ///Path relative to the Assetto Corsa Server folder
  final String path;

  final List<Layout> layouts;

  final _TrackInfo? info;

  const Track({
    required this.circuitName,
    required this.name,
    required this.path,
    required this.layouts,
    this.info,
  });

  static Future<Track> fromData(Directory directory) async {
    List<Layout> layouts = [
      const Layout(
          name: 'Test layout',
          path:
              'D:/Giochi/Steam/steamapps/common/assettocorsa/content/tracks/ks_barcelona/ui/layout_gp'),
    ];
    return Track(
      path: directory.path,
      circuitName: '',
      layouts: layouts,
      name: '',
      info: _TrackInfo.fromJson(
        jsonDecode(await File(directory.path.replaceAll('\\', '/') + kUiDirPath)
            .readAsString()),
      ),
    );
  }
}

class _TrackInfo {
  final String description;
  final String country;
  final int length;

  ///1 is clockwise
  final int run;
  final int pitBoxes;

  const _TrackInfo({
    required this.description,
    required this.country,
    required this.length,
    required this.run,
    required this.pitBoxes,
  });

  factory _TrackInfo.fromJson(Map<String, dynamic> json) {
    return _TrackInfo(
      description: json['description'],
      country: json['country'],
      length: json['length'],
      run: json['run'] == "clockwise" ? 1 : 0,
      pitBoxes: int.tryParse(json['pitboxes']) ?? 0,
    );
  }
}
