import 'dart:io';
import 'dart:ui';

import 'package:flutter_app_group_directory/flutter_app_group_directory.dart';
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
            await FlutterAppGroupDirectory.getAppGroupDirectory(
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

          assert(
            imageWidth > 0,
            'Please make sure you are using an image that is not corrupt or too small',
          );

          final targetWidth = (imageWidth * value.resizeFactor).round();
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
        await FlutterAppGroupDirectory.getAppGroupDirectory(appGroupId!);
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
  final bytes = await file.readAsBytes();
  final image = img.decodeImage(bytes);

  if (image == null) {
    throw Exception("Invalid image file");
  }

  final imageWidth = image.width;
  final imageHeight = image.height;
  final targetHeight = (imageHeight * targetWidth / imageWidth).round();

  final resizedImage =
      img.copyResize(image, width: targetWidth, height: targetHeight);

  final compressedBytes = img.encodeJpg(resizedImage, quality: 85);
  return File(file.path)..writeAsBytesSync(compressedBytes);
}
