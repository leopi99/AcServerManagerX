import 'package:acservermanager/models/layout.dart';

class Track {
  static const String _kUiDirPath = "/ui";

  final String name;
  final String circuitName;

  ///Path relative to the Assetto Corsa Server folder
  final String path;

  final List<Layout> layouts;

  const Track({
    required this.circuitName,
    required this.name,
    required this.path,
    required this.layouts,
  });
}
