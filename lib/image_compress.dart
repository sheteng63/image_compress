import 'dart:async';

import 'package:flutter/services.dart';

class ImageCompress {
  static const MethodChannel _channel =
      const MethodChannel('image_compress');

  static Future<List<int>> compressImage(String path,{rate = 1,width = 500,height = 500}) async {
    var s = await _channel.invokeMethod("compressImage",{"path": path,"rate":rate,"width":width,"height":height});
    return s;
  }

}
