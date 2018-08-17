import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class ImageCompress {
  static const MethodChannel _channel = const MethodChannel('image_compress');

  static Future<List<int>> compressImageToMemory(String path,
      {rate = 1, width = 500, height = 500}) async {
    return await _channel.invokeMethod("compressImage",
        {"path": path, "rate": rate, "width": width, "height": height});
  }

}
