class Layout {
  static const String _kPreviewImagePath = "/preview.png";
  static const String _kOutlineImagePath = "/outline.png";
  final String name;

  ///The path should always end with "/"
  final String path;

  const Layout({
    required this.name,
    required this.path,
  });

  String get previewImagePath => "$path$_kPreviewImagePath";
  String get outlineImagePath => "$path$_kOutlineImagePath";
}
