import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:image_gallery_saver/image_gallery_saver.dart';

class SelfieRepository {
  Future<img.Image?> _decodeImageFile(File imageFile) async {
    return await img.decodeImageFile(imageFile.path);
  }

  // 写真を端末に保存する
  Future<void> saveSelfie(File selfie) async {
    if (Platform.isAndroid) {
      final decodedImage = await _decodeImageFile(selfie);
      if (decodedImage == null) {
        return;
      }

      // 左90度回転し保存されるため、保存前に回転していない状態の画像データの生成を行う。
      final rotatedImage = img.copyRotate(decodedImage, angle: 0);
      final newSelfie = await selfie.writeAsBytes(
        img.encodeJpg(rotatedImage, quality: 50),
      );
      await _saveImageFromByte(newSelfie);
      return;
    }

    await _saveImageFromByte(selfie);
  }

  /// 画像データから画像を端末のアルバム内に保存する。
  Future<void> _saveImageFromByte(File imageFile) async {
    await ImageGallerySaver.saveImage(
      imageFile.readAsBytesSync(),
    );
  }
}
