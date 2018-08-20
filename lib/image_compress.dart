import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

class ImageCompress {
  static const MethodChannel _channel = const MethodChannel('image_compress');

  /**
   * path: the image path
   * rate: compress rate range(0~1)
   * width: new image width
   * height: new image height
   * return: new image memory
   */
  static Future<List<int>> compressImageToMemory(String path,
      {rate = 1, width = 500, height = 500}) async {
    return await _channel.invokeMethod("compressImage",
        {"path": path, "rate": rate, "width": width, "height": height});
  }

  /**
   * path: the image path
   * rate: compress rate range(0~1)
   * width: new image width
   * height: new image height
   * return: new image memory
   */
  static Future compressImageToFile(String path,File file,
      {rate = 1, width = 500, height = 500}) async {
    var res = await _channel.invokeMethod("compressImage",
        {"path": path, "rate": rate, "width": width, "height": height});
    await (await file).writeAsString(res);

  }

}
