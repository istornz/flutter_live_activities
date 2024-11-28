import 'dart:io';
import 'dart:ui';

import 'package:image/image.dart' as img;

class ImageFileService {
  Future resizeImage(File file, num resizeFactor) async {
    final bytes = file.readAsBytesSync();
    final buffer = await ImmutableBuffer.fromUint8List(bytes);
    final descriptor = await ImageDescriptor.encoded(buffer);
    final imageWidth = descriptor.width;

    assert(
      imageWidth > 0,
      'Please make sure you are using an image that is not corrupt or too small',
    );

    final targetWidth = (imageWidth * resizeFactor).round();
    return _compressImage(file, targetWidth);
  }

  Future<File> _compressImage(File file, int targetWidth) async {
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
}
