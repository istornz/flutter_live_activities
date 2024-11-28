import 'package:flutter/services.dart';

class LiveActivityImageFileOptions {
  num? resizeFactor;

  LiveActivityImageFileOptions({this.resizeFactor});
}

abstract class LiveActivityFile {
  final LiveActivityImageFileOptions? imageOptions;

  LiveActivityFile(this.imageOptions);

  /// Load the image.
  Future<Uint8List> loadFile();
  String get fileName;
}

class LiveActivityFileFromUrl extends LiveActivityFile {
  final String url;

  LiveActivityFileFromUrl._(
    this.url,
    LiveActivityImageFileOptions? imageOptions,
  ) : super(
          imageOptions,
        );

  factory LiveActivityFileFromUrl(
    String url,
  ) {
    return LiveActivityFileFromUrl._(url, null);
  }

  factory LiveActivityFileFromUrl.image(
    String url, {
    LiveActivityImageFileOptions? imageOptions,
  }) {
    return LiveActivityFileFromUrl._(url, imageOptions);
  }

  @override
  Future<Uint8List> loadFile() async {
    final ByteData byteData = await NetworkAssetBundle(Uri.parse(url)).load('');
    return byteData.buffer.asUint8List();
  }

  @override
  String get fileName => url.split('/').last;
}

class LiveActivityFileFromAsset extends LiveActivityFile {
  final String path;

  LiveActivityFileFromAsset._(
    this.path,
    LiveActivityImageFileOptions? options,
  ) : super(
          options,
        );

  factory LiveActivityFileFromAsset(
    String path,
  ) {
    return LiveActivityFileFromAsset._(path, null);
  }

  factory LiveActivityFileFromAsset.image(
    String path, {
    LiveActivityImageFileOptions? imageOptions,
  }) {
    return LiveActivityFileFromAsset._(
      path,
      imageOptions,
    );
  }

  @override
  Future<Uint8List> loadFile() async {
    final byteData = await rootBundle.load(path);
    return byteData.buffer.asUint8List();
  }

  @override
  String get fileName => path.split('/').last;
}

class LiveActivityFileFromMemory extends LiveActivityFile {
  final Uint8List data;
  final String imageName;

  LiveActivityFileFromMemory._(
    this.data,
    this.imageName,
    LiveActivityImageFileOptions? imageOptions,
  ) : super(
          imageOptions,
        );

  factory LiveActivityFileFromMemory(
    Uint8List data,
    String imageName,
  ) {
    return LiveActivityFileFromMemory._(data, imageName, null);
  }

  factory LiveActivityFileFromMemory.image(
    Uint8List data,
    String imageName, {
    LiveActivityImageFileOptions? imageOptions,
  }) {
    return LiveActivityFileFromMemory._(data, imageName, imageOptions);
  }

  @override
  Future<Uint8List> loadFile() {
    return Future.value(data);
  }

  @override
  String get fileName => throw UnimplementedError();
}
