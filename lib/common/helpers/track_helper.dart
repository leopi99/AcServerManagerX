import 'dart:io';

import 'package:acservermanager/common/logger.dart';
import 'package:acservermanager/models/track.dart';

class TrackHelper {
  static const String _kTracksPath = "/content/tracks";

  static Future<List<Track>> loadTracks(
      {required String acPath, required Function(String) onError}) async {
    final trackDir = Directory(acPath + _kTracksPath);

    List<Track> tracks = [];

    int index = 0;

    try {
      await Future.forEach<FileSystemEntity>(trackDir.listSync(),
          (element) async {
        final dir = Directory(element.path);
        tracks.add(await Track.fromDir(dir, index));
        index++;
      });
    } catch (e, stacktrace) {
      Logger().log('Error: $e\nStackTrace:\n$stacktrace');
      onError("${e.toString()} Stacktrace:\n$stacktrace");
      return [];
    }
    return tracks;
  }

  ///Loads a single [Track] from [trackPath].
  ///
  ///If the result is null, the track couldn't be loaded
  static Future<Track?> loadTrackFrom(String trackPath) async {
    final Directory dir = Directory(trackPath);
    if (!dir.existsSync()) return null;

    Track? track;
    try {
      track = await Track.fromDir(dir, 0);
    } catch (e) {
      Logger().log(e.toString(), name: "loadTrackFrom");
      return null;
    }
    return track;
  }
}
