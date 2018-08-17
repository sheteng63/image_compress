package com.example.imagecompress;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** ImageCompressPlugin */
public class ImageCompressPlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "image_compress");
    channel.setMethodCallHandler(new ImageCompressPlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("compressImage")) {
      String path = call.argument("path");
      float rate = call.argument("rate");
      float width = call.argument("width");
      float height = call.argument("height");
      result.success(getimage(path,width,height,rate));
    } else {
      result.notImplemented();
    }
  }

  private byte[] getimage(String srcPath,float width,float height,float rate) {
    BitmapFactory.Options newOpts = new BitmapFactory.Options();
    //开始读入图片，此时把options.inJustDecodeBounds 设回true了
    newOpts.inJustDecodeBounds = true;
    Bitmap bitmap = BitmapFactory.decodeFile(srcPath,newOpts);//此时返回bm为空

    newOpts.inJustDecodeBounds = false;
    int w = newOpts.outWidth;
    int h = newOpts.outHeight;
    //现在主流手机比较多是800*480分辨率，所以高和宽我们设置为//这里设置宽度为480f
    //缩放比。由于是固定比例缩放，只用高或者宽其中一个数据进行计算即可
    int be = 1;//be=1表示不缩放
    if (w > h && w > width) {//如果宽度大的话根据宽度固定大小缩放
      be = (int) (newOpts.outWidth / width);
    } else if (w < h && h > height) {//如果高度高的话根据宽度固定大小缩放
      be = (int) (newOpts.outHeight / height);
    }
    if (be <= 0)
      be = 1;
    newOpts.inSampleSize = be;//设置缩放比例
    //重新读入图片，注意此时已经把options.inJustDecodeBounds 设回false了
    bitmap = BitmapFactory.decodeFile(srcPath, newOpts);
    return compressImage(bitmap,rate);//压缩好比例大小后再进行质量压缩
  }

  private byte[] compressImage(Bitmap image,float rate) {

    ByteArrayOutputStream baos = new ByteArrayOutputStream();
    image.compress(Bitmap.CompressFormat.JPEG, (int) (100 * rate), baos);//质量压缩方法，这里100表示不压缩，把压缩后的数据存放到baos中
    return baos.toByteArray();
  }
}
