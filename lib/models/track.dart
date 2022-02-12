import 'dart:convert';
import 'dart:io';

import 'package:acservermanager/models/layout.dart';
import 'package:flutter/foundation.dart';

class Track {
  static const String kUiDirPath = "/ui";
  static const String kPreviewPath = '$kUiDirPath/preview.png';
  static const String kTrackInfoFilePath = "/ui_track.json";
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
    List<Layout> layouts = [];
    final Directory uiDir = Directory(directory.path + kUiDirPath);
    final bool hasLayouts = !uiDir
        .listSync()
        .any((element) => element.path.split('/').last.contains('.json'));
    if (hasLayouts) {
      layouts.add(const Layout(
          name: 'Default',
          path:
              'D:/Giochi/Steam/steamapps/common/assettocorsa/content/tracks/ks_barcelona/ui/layout_gp'));
      debugPrint('Found more layouts ${directory.path}');
    } else {
      //Has only one layout
      debugPrint('Found only one layout ${directory.path}');
      layouts.add(Layout(name: 'Default', path: uiDir.path));
    }
    _TrackInfo? info = !hasLayouts
        ? _TrackInfo.fromJson(
            jsonDecode(
              await File(_getTrackInfoPath(directory.path)).readAsString(),
            ),
          )
        : null;
    //TODO: Find the layouts
    return Track(
      index: index,
      path: directory.path,
      circuitName: info?.name ?? 'NoName',
      layouts: layouts,
      name: info?.description ?? '',
      info: info,
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
  final String name;

  ///1 is clockwise
  final int run;
  final int pitBoxes;

  const _TrackInfo({
    required this.description,
    required this.country,
    required this.length,
    required this.run,
    required this.pitBoxes,
    required this.name,
  });

  factory _TrackInfo.fromJson(Map<String, dynamic> json) {
    return _TrackInfo(
      description: json['description'],
      country: json['country'],
      length: json['length'],
      run: json['run'] == "clockwise" ? 1 : 0,
      pitBoxes: int.tryParse(json['pitboxes']) ?? 0,
      name: json['name'],
    );
  }
}
