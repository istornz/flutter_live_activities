import 'dart:io';

import 'package:flutter_app_group_directory/flutter_app_group_directory.dart';
import 'package:live_activities/models/live_activity_file.dart';
import 'package:live_activities/services/image_file_service.dart';
import 'package:path_provider/path_provider.dart';

const kFileFolderName = 'LiveActivitiesFiles';

class AppGroupsFileService {
  final _imageService = ImageFileService();

  String? _appGroupId;
  final List<String> _assetsCopiedInAppGroups = [];

  init({required String appGroupId}) {
    _appGroupId = appGroupId;
  }

  Future sendFilesToAppGroups(Map<String, dynamic> data) async {
    if (_appGroupId == null) {
      throw Exception('appGroupId is null. Please call init() first.');
    }

    for (String key in data.keys) {
      final value = data[key];

      if (value is! LiveActivityFile) {
        continue;
      }

      Directory appGroupFiles = await _liveActivitiesFilesDirectory();
      Directory tempDir = await getTemporaryDirectory();

      // create directory if not exists
      appGroupFiles.createSync();

      final bytes = await value.loadFile();
      File file = await File('${tempDir.path}/${value.fileName}').create()
        ..writeAsBytesSync(bytes);

      if (value.imageOptions != null) {
        await _processImageFileOperations(file, value.imageOptions!);
      }

      final finalDestination = '${appGroupFiles.path}/${value.fileName}';
      file.copySync(finalDestination);

      data[key] = finalDestination;
      _assetsCopiedInAppGroups.add(finalDestination);

      // remove file from temp directory
      file.deleteSync();
    }
  }

  Future<void> removeAllFiles() async {
    final laFilesDir = await _liveActivitiesFilesDirectory();
    laFilesDir.deleteSync(recursive: true);
  }

  Future<void> removeFilesSession() async {
    for (String filePath in _assetsCopiedInAppGroups) {
      final file = File(filePath);
      await file.delete();
    }
  }

  Future _processImageFileOperations(
    File file,
    LiveActivityImageFileOptions imageOptions,
  ) async {
    if (imageOptions.resizeFactor != null && imageOptions.resizeFactor != 1) {
      file = await _imageService.resizeImage(file, imageOptions.resizeFactor!);
    }
  }

  Future<Directory> _liveActivitiesFilesDirectory() async {
    final appGroupDirectory =
        await FlutterAppGroupDirectory.getAppGroupDirectory(_appGroupId!);
    return Directory(
      '${appGroupDirectory!.path}/$kFileFolderName',
    );
  }
}
