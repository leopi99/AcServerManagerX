import 'dart:io';

class CarSkin {
  static const String _kCarSkin = '/preview.jpg';
  static const String _kCarLivery = '/livery.png';
  final String path;

  const CarSkin({
    required this.path,
  });

  factory CarSkin.fromDir(Directory dir) {
    return CarSkin(path: dir.path);
  }

  String get previewPath => '$path$_kCarSkin';
  String get liveryPath => '$path$_kCarLivery';
}
