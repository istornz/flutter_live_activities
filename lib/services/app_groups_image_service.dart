import 'dart:io';
import 'dart:ui';

import 'package:app_group_directory/app_group_directory.dart';
import 'package:live_activities/models/live_activity_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;


const kPictureFolderName = 'LiveActivitiesPictures';

class AppGroupsImageService {
  String? appGroupId;
  final List<String> _assetsCopiedInAppGroups = [];

  Future sendImageToAppGroups(Map<String, dynamic> data) async {
    if (appGroupId == null) {
      throw Exception('appGroupId is null. Please call init() first.');
    }

    for (String key in data.keys) {
      final value = data[key];

      if (value is LiveActivityImage) {
        Directory? sharedDirectory =
            await AppGroupDirectory.getAppGroupDirectory(
          appGroupId!,
        );
        Directory appGroupPicture =
            Directory('${sharedDirectory!.path}/$kPictureFolderName');
        Directory tempDir = await getTemporaryDirectory();

        // create directory if not exists
        appGroupPicture.createSync();

        late File file;
        late String fileName;
        if (value is LiveActivityImageFromAsset) {
          fileName = (value.path.split('/').last);
        } else if (value is LiveActivityImageFromUrl) {
          fileName = (value.url.split('/').last);
        } else if (value is LiveActivityImageFromMemory) {
          fileName = value.imageName;
        }

        final bytes = await value.loadImage();
        file = await File('${tempDir.path}/$fileName').create();
        file.writeAsBytesSync(bytes);

        if (value.resizeFactor != 1) {
          final buffer = await ImmutableBuffer.fromUint8List(bytes);
          final descriptor = await ImageDescriptor.encoded(buffer);
          final imageWidth = descriptor.width;
          final imageHeight = descriptor.height;

          assert(
            imageWidth > 0,
            'Please make sure you are using an image that is not corrupt or too small',
          );

          final targetWidth = (imageWidth * value.resizeFactor).round();

          /*file = await FlutterNativeImage.compressImage(
            file.path,
            targetWidth: targetWidth,
            targetHeight: (imageHeight * targetWidth / imageWidth).round(),
          );*/

          file = await compressImage(file, targetWidth);
        }

        final finalDestination = '${appGroupPicture.path}/$fileName';
        file.copySync(finalDestination);

        data[key] = finalDestination;
        _assetsCopiedInAppGroups.add(finalDestination);

        // remove file from temp directory
        file.deleteSync();
      }
    }
  }

  Future<void> removeAllImages() async {
    final appGroupDirectory =
        await AppGroupDirectory.getAppGroupDirectory(appGroupId!);
    final laPictureDir = Directory(
      '${appGroupDirectory!.path}/$kPictureFolderName',
    );
    laPictureDir.deleteSync(recursive: true);
  }

  Future<void> removeImagesSession() async {
    for (String filePath in _assetsCopiedInAppGroups) {
      final file = File(filePath);
      await file.delete();
    }
  }
}
Future<File> compressImage(File file, int targetWidth) async {
  // Lade das Bild von der Datei
  final bytes = await file.readAsBytes();
  final image = img.decodeImage(bytes);

  if (image == null) {
    throw Exception("Das Bild konnte nicht geladen werden.");
  }

  // Berechne die Zielhöhe basierend auf den Bilddimensionen
  final imageWidth = image.width;
  final imageHeight = image.height;
  final targetHeight = (imageHeight * targetWidth / imageWidth).round();

  // Skaliere das Bild auf die Zielgröße
  final resizedImage = img.copyResize(image, width: targetWidth, height: targetHeight);

  // Komprimiere das Bild als JPEG
  final compressedBytes = img.encodeJpg(resizedImage, quality: 85);

  // Speichere das komprimierte Bild in einer neuen Datei
  final compressedFile = File(file.path)..writeAsBytesSync(compressedBytes);

  return compressedFile;
}
