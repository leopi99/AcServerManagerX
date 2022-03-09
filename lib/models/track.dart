import 'dart:convert';
import 'dart:io';

import 'package:acservermanager/common/logger.dart';
import 'package:acservermanager/models/layout.dart';
import 'package:acservermanager/models/searcheable_element.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Track extends SearcheableElement implements Equatable {
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
  }) : super(name);

  static Future<Track> fromDir(Directory directory, int index) async {
    List<Layout> layouts = [];
    final Directory uiDir = Directory(directory.path + kUiDirPath);
    final bool hasLayouts = !await (uiDir.list())
        .any((element) => element.path.split('/').last.contains('.json'));
    _TrackInfo? info = !hasLayouts
        ? _TrackInfo.fromJson(
            jsonDecode(
              await File(
                      _getTrackInfoPath(directory.path.replaceAll('\\', '/')))
                  .readAsString(),
            ),
          )
        : null;
    //If true, the track has more than one layout
    if (hasLayouts) {
      await Future.forEach(
        uiDir.listSync(),
        (element) async {
          element as FileSystemEntity;
          if (element.path.contains('.dds')) return;
          final Directory layoutDir =
              Directory(element.path.replaceAll('//', '/'));
          String? name;
          try {
            final String fileContent = String.fromCharCodes((await File(
                    (layoutDir.path + kTrackInfoFilePath).replaceAll('\\', '/'))
                .readAsBytes()));
            name = jsonDecode(fileContent)['name'];
          } catch (e, stacktrace) {
            Logger().log("Error: $e, stacktrace:\n$stacktrace");
          }
          layouts.add(
            Layout(
              name: name ?? 'NoName',
              path: layoutDir.path.replaceAll('//', '/'),
            ),
          );
        },
      );
    } else {
      layouts.add(
        Layout(
            name: info?.name ?? 'Default',
            path: uiDir.path.replaceAll('\\', '/')),
      );
    }

    return Track(
      index: index,
      path: directory.path,
      circuitName: info?.name ??
          directory.path
              .replaceAll('\\', '/')
              .split('/')
              .last
              .replaceAll("_", " ")
              .replaceFirst('ks', '')
              .trim(),
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

  @override
  String get searchTerm => name;

  @override
  List<Object?> get props => [
        name,
        circuitName,
        path,
        layouts,
        index,
        info,
      ];

  @override
  bool? get stringify => true;

  Track copyWith({
    String? name,
    String? circuitName,
    String? path,
    List<Layout>? layouts,
    int? index,
    _TrackInfo? info,
  }) {
    return Track(
      name: name ?? this.name,
      circuitName: circuitName ?? this.circuitName,
      path: path ?? this.path,
      layouts: layouts ?? this.layouts,
      index: index ?? this.index,
      info: info ?? this.info,
    );
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
