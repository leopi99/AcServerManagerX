import 'dart:convert';
import 'dart:io';

import 'package:acservermanager/common/logger.dart';
import 'package:acservermanager/models/car/skin_details.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class CarSkin extends Equatable {
  static const String _kCarSkin = '/preview.jpg';
  static const String _kCarLivery = '/livery.png';
  static const String _kSkinDetails = '/ui_skin.json';
  final String path;
  final SkinDetails? details;

  const CarSkin({
    required this.path,
    required this.details,
  });

  static Future<CarSkin> fromDir(Directory dir, int index) async {
    SkinDetails? details;
    final File file = File(dir.path + _kSkinDetails);
    if (file.existsSync()) {
      try {
        final String fileContent =
            String.fromCharCodes(await file.readAsBytes());
        details = SkinDetails.fromJson(
          json.decode(fileContent),
          name: dir.path.replaceAll('\\', '/').split('/').last,
        );
      } catch (e, stacktrace) {
        Logger().log("For car ${dir.path}");
        Logger().log(
            'Error retrieving skin details: $e\nStacktrace: $stacktrace');
      }
    }
    return CarSkin(
      path: dir.path,
      details: details,
    );
  }

  String get previewPath => '$path$_kCarSkin';

  String get liveryPath => '$path$_kCarLivery';

  @override
  List<Object?> get props => [path, details];
}
