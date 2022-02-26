import 'dart:io';

import 'package:acservermanager/models/track.dart';
import 'package:flutter/foundation.dart';

class TrackHelper {
  static const String _kTracksPath = "/content/tracks";

  static Future<List<Track>> loadTracks(
      {required String acPath, required Function(String) onError}) async {
    final trackDir = Directory(acPath + _kTracksPath);

    List<Track> tracks = [];

    int index = 0;

    try {
      await Future.forEach(trackDir.listSync(), (element) async {
        element as FileSystemEntity;
        final dir = Directory(element.path);
        tracks.add(await Track.fromData(dir, index));
        index++;
      });
    } catch (e, stacktrace) {
      debugPrint('Error: $e\nStackTrace:\n$stacktrace');
      onError(e.toString());
      return [];
    }
    return tracks;
  }
}
