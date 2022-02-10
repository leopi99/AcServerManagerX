import 'dart:convert';
import 'dart:io';

import 'package:acservermanager/models/layout.dart';

class Track {
  static const String kUiDirPath = "/ui";
  static const String kPreviewPath = '$kUiDirPath/preview.png';

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

  factory Track.fromData(Directory directory) {
    return Track(
      path: directory.path,
      circuitName: '',
      layouts: [],
      name: '',
      info: _TrackInfo.fromJson(
        jsonDecode(File(directory.path + kPreviewPath).readAsStringSync()),
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
