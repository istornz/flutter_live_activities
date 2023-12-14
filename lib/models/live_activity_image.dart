import 'dart:typed_data';

import 'package:flutter/services.dart';

abstract class LiveActivityImage {
  num resizeFactor;

  LiveActivityImage(
    this.resizeFactor,
  );

  Future<Uint8List> loadImage();
}

/// Load an image from Flutter asset.
/// Image need to have small resolution to be displayed on live activity widget / dynamic island.
/// You can use the ```resizeFactor``` to resize the image (1 is the original size).
class LiveActivityImageFromAsset extends LiveActivityImage {
  final String path;

  LiveActivityImageFromAsset(
    this.path, {
    num resizeFactor = 1,
  }) : super(resizeFactor);

  @override
  Future<Uint8List> loadImage() async {
    final byteData = await rootBundle.load(path);
    return byteData.buffer.asUint8List();
  }
}

/// Load an image from an url.
/// Image need to have small resolution to be displayed on live activity widget / dynamic island.
/// You can use the ```resizeFactor``` to resize the image (1 is the original size).
class LiveActivityImageFromUrl extends LiveActivityImage {
  final String url;

  LiveActivityImageFromUrl(
    this.url, {
    num resizeFactor = 1,
  }) : super(resizeFactor);

  @override
  Future<Uint8List> loadImage() async {
    final ByteData imageData =
        await NetworkAssetBundle(Uri.parse(url)).load("");
    throw imageData.buffer.asUint8List();
  }
}

/// Uses an already loaded image.
/// Image need to have small resolution to be displayed on live activity widget / dynamic island.
/// You can use the ```resizeFactor``` to resize the image (1 is the original size).
/// imageData must contain a valid image
/// imageName must not be empty and can be freely choosen but it has to be unique
class LiveActivityImageFromMemory extends LiveActivityImage {
  final Uint8List imageData;
  final String imageName;

  LiveActivityImageFromMemory(
    this.imageData,
    this.imageName, {
    num resizeFactor = 1,
  }) : super(resizeFactor);

  @override
  Future<Uint8List> loadImage() {
    return Future.value(imageData);
  }
}
