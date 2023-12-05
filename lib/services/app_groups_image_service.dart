import 'dart:io';

import 'package:app_group_directory/app_group_directory.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:live_activities/models/live_activity_image.dart';
import 'package:path_provider/path_provider.dart';

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
          final assetImagePath = value;
          final byteData = await rootBundle.load(assetImagePath.path);
          fileName = (assetImagePath.path.split('/').last);

          file = File('${tempDir.path}/$fileName');
          await file.writeAsBytes(byteData.buffer
              .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
        } else if (value is LiveActivityImageFromUrl) {
          final urlImagePath = value;
          fileName = (urlImagePath.url.split('/').last);

          final ByteData imageData =
              await NetworkAssetBundle(Uri.parse(urlImagePath.url)).load("");
          final Uint8List bytes = imageData.buffer.asUint8List();
          file = await File('${tempDir.path}/$fileName').create();
          file.writeAsBytesSync(bytes);
        }

        if (value.resizeFactor != 1) {
          ImageProperties properties =
              await FlutterNativeImage.getImageProperties(file.path);

          final targetWidth = (properties.width! * value.resizeFactor).round();
          file = await _compressToSize(
            file.path,
            150,
            75,
          );

          file = await FlutterNativeImage.compressImage(
            file.path,
            targetWidth: targetWidth,
            targetHeight:
                (properties.height! * targetWidth / properties.width!).round(),
          );
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

Future<File> _compressToSize(
  String path,
  int targetWidthPixels,
  int maxSizeKb,
) async {
  File compressedFile = await _compressImageToWidth(path, targetWidthPixels);
  int maxSizeBytes = maxSizeKb * 1000;
  int loopLimit = 4;
  while ((compressedFile.lengthSync() > maxSizeBytes) && loopLimit-- > 0) {
    int percentage =
        ((maxSizeBytes / compressedFile.lengthSync()) * 100).round();
    compressedFile = await FlutterNativeImage.compressImage(
      path,
      percentage: percentage,
    );
  }
  if (compressedFile.lengthSync() > maxSizeBytes) {
    throw Exception('Could not compress image to size');
  }
  return compressedFile;
}

/// Throws exception if we can't get width and height attributes
Future<File> _compressImageToWidth(String path, int targetWidth) async {
  ImageProperties properties =
      await FlutterNativeImage.getImageProperties(path);
  int? originalWidth = properties.width;
  int? originalHeight = properties.height;

  if (originalWidth == null || originalHeight == null) {
    throw Exception('Could not get width and height of image');
  }

  if (originalWidth < targetWidth) {
    return File(path);
  }

  // Height multiplier
  final double heightMultiplier = targetWidth / originalWidth * originalHeight;
  // TODO: replace this with a less janky plugin?
  return FlutterNativeImage.compressImage(
    path,
    targetWidth: targetWidth,
    targetHeight: heightMultiplier.round(),
  );
}
