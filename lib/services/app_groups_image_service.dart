import 'dart:io';

import 'package:app_group_directory/app_group_directory.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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

          final finalDestination = '${appGroupPicture.path}/$fileName';
          file.copySync(finalDestination);

          data[key] = finalDestination;
          _assetsCopiedInAppGroups.add(finalDestination);

          // remove file from temp directory
          file.deleteSync();
        } else if (value is LiveActivityImageFromUrl) {
          final urlImagePath = value;

          Directory tempDir = await getTemporaryDirectory();
          Uint8List? bytes;
          var fileName = (urlImagePath.url.split('/').last).split('?').first;
          var fileNameNew = 'copy${fileName.split('?').first}';
          var fileFormat = fileName.split('.').last;
          final ByteData imageData;
          if (fileFormat != 'svg') {
            imageData =
                await NetworkAssetBundle(Uri.parse(urlImagePath.url)).load("");

            bytes = imageData.buffer.asUint8List();
          }

          var file = await File('${tempDir.path}/$fileName').create();
          var fileNew = await File('${tempDir.path}/$fileNameNew').create();
          if (bytes != null) {
            file.writeAsBytesSync(bytes);

            var result = await FlutterImageCompress.compressAndGetFile(
              file.path,
              fileNew.path,
              format: fileFormat == CompressFormat.png.name
                  ? CompressFormat.png
                  : CompressFormat.jpeg,
              minHeight: urlImagePath.minHeight,
              minWidth: urlImagePath.minWidth,
            );

            file = await File(result!.path).create();
            final finalDestination = '${appGroupPicture.path}/$fileName';
            file.copySync(finalDestination);

            data[key] = finalDestination;
            _assetsCopiedInAppGroups.add(finalDestination);

            file.delete();
          }
        }
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
