import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'dart:core';

import 'package:flutter/painting.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ImageUtils {
  static Future<File> resizeImage(File file, {int? height = 450, int? width}) async {
    Image image = await decodeImageFromList(file.readAsBytesSync());
    final imageBytes = await image.toByteData();

    // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
    final codec = await instantiateImageCodec(imageBytes!.buffer.asUint8List(), targetHeight: height, targetWidth: width);

    final frameInfo = await codec.getNextFrame();

    Image i = frameInfo.image;
    
    print('image width is ${i.width}');//height of resized image
    print('image height is ${i.height}');//width of resized image

    final bytes = await i.toByteData();

    // save in cache
    final directory = await getTemporaryDirectory();

    final tempFile = File(directory.path + '/' + basename(file.path));

    return tempFile.writeAsBytes(bytes!.buffer.asUint8List());
  }

  static CompressFormat _getFormat(String path) {
    if (path.endsWith('.png')) {
      return CompressFormat.png;
    } else if (path.endsWith('.webp')) {
      return CompressFormat.webp;
    } else if (path.endsWith('.heic')) {
      return CompressFormat.heic;
    } else {
      return CompressFormat.jpeg;
    }
  }

  static Future<XFile?> testCompressAndGetFile(File file) async {
    final directory = await getTemporaryDirectory();

    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        '${directory.path}/temp_${basename(file.path)}',
        minHeight: 450,
        minWidth: 450,
        format: _getFormat(basename(file.path)),
      );

    print(file.lengthSync());
    print(await result?.length());

    return result;
  }

  static String noise({int length = 10}) {
    Random rand = Random.secure();
    String string = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890-",
           output = "";

    for (var i = 0; i < length; i++) {
      output += string[rand.nextInt(string.length - 1)];
    }

    return output;
  }
}