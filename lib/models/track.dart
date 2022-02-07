class Track {
  final String name;
  final String circuitName;

  ///Path relative to the Assetto Corsa Server folder
  final String path;

  const Track({
    required this.circuitName,
    required this.name,
    required this.path,
  });
}
