import 'dart:io';

import 'package:flutter_app_group_directory/flutter_app_group_directory.dart';
import 'package:live_activities/models/live_activity_file.dart';
import 'package:live_activities/services/image_file_service.dart';
import 'package:path_provider/path_provider.dart';

/// Folder name to store files in the app groups directory
const kFileFolderName = 'LiveActivitiesFiles';

/// Service to handle all processes to files that are sent to the app groups
class AppGroupsFileService {
  final _imageService = ImageFileService();

  String? _appGroupId;
  final List<String> _assetsCopiedInAppGroups = [];

  /// Initialize the service with the app group id
  init({required String appGroupId}) {
    _appGroupId = appGroupId;
  }

  /// Send files to the app groups directory
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

  /// Remove all files from the app group directory
  Future<void> removeAllFiles() async {
    final laFilesDir = await _liveActivitiesFilesDirectory();
    laFilesDir.deleteSync(recursive: true);
  }

  /// Remove all files that were copied to the app groups in this session
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
