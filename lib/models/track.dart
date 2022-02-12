import 'dart:convert';
import 'dart:io';

import 'package:acservermanager/models/layout.dart';

class Track {
  static const String kUiDirPath = "/ui";
  static const String kPreviewPath = '$kUiDirPath/preview.png';
  static const String kTrackInfoFilePath = "ui_track.json";
  static const String kUiTrackInfo = '$kUiDirPath/$kTrackInfoFilePath';

  final String name;
  final String circuitName;

  ///Path relative to the Assetto Corsa Server folder
  final String path;

  final List<Layout> layouts;

  final _TrackInfo? info;

  final int index;

  const Track({
    required this.circuitName,
    required this.name,
    required this.path,
    required this.layouts,
    required this.index,
    this.info,
  });

  static Future<Track> fromData(Directory directory, int index) async {
    List<Layout> layouts = [
      const Layout(
          name: 'Test layout',
          path:
              'D:/Giochi/Steam/steamapps/common/assettocorsa/content/tracks/ks_barcelona/ui/layout_gp'),
    ];
    //TODO: Find the layouts
    return Track(
      index: index,
      path: directory.path,
      circuitName: 'Test track$index',
      layouts: layouts,
      name: '',
      // info: _TrackInfo.fromJson(
      //   jsonDecode(
      //     await File(_getTrackInfoPath(directory.path)).readAsString(),
      //   ),
      // ),
    );
  }

  static String _getTrackInfoPath(String path, {String? layoutName}) {
    String layout = "";
    if (layoutName != null) {
      layout = "/$layoutName/";
    }
    return path.replaceAll('\\', '/') +
        kUiDirPath +
        layout +
        kTrackInfoFilePath;
  }
}

class _TrackInfo {
  final String description;
  final String country;
  final String length;

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
