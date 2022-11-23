abstract class LiveActivityImage {
  num resizeFactor;

  LiveActivityImage(
    this.resizeFactor,
  );
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
}
