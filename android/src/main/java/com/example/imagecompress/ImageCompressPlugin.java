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

/**
 * ImageCompressPlugin
 */
public class ImageCompressPlugin implements MethodCallHandler {
    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "image_compress");
        channel.setMethodCallHandler(new ImageCompressPlugin());
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("compressImage")) {
            String path = call.argument("path");
            double rate = call.argument("rate");
            double width = call.argument("width");
            double height = call.argument("height");
            result.success(getimage(path, width, height, rate));
        } else {
            result.notImplemented();
        }
    }

    private byte[] getimage(String srcPath, double Dwidth, double Dheight, double rate) {
        BitmapFactory.Options newOpts = new BitmapFactory.Options();
        //开始读入图片，此时把options.inJustDecodeBounds 设回true了
        newOpts.inJustDecodeBounds = true;
        Bitmap bitmap = BitmapFactory.decodeFile(srcPath, newOpts);//此时返回bm为空

        newOpts.inJustDecodeBounds = false;
        int width = newOpts.outWidth;
        int height = newOpts.outHeight;
        //现在主流手机比较多是800*480分辨率，所以高和宽我们设置为//这里设置宽度为480f
        //缩放比。由于是固定比例缩放，只用高或者宽其中一个数据进行计算即可
        double be = 1;//be=1表示不缩放
        if (Dwidth == 0.0 || Dheight == 0.0) {
            if (width > 1280 || height > 1280) {
                if (width > height) {
                    be = height / width;
                    width = 1280;
                    height = (int) (width * be);
                } else {
                    be = width / height;
                    height = 1280;
                    width = (int) (height * be);
                }
                //2.宽大于1280高小于1280
            } else if (width > 1280 || height < 1280) {
                be = height / width;
                width = 1280;
                height = (int) (width * be);
                //3.宽小于1280高大于1280
            } else if (width < 1280 || height > 1280) {
                be = width / height;
                height = 1280;
                width = (int) (height * be);
                //4.宽高都小于1280
            } else {
            }

        } else if (Dwidth < width && Dheight < height) {
            if (Dwidth / width > Dheight / height) {
                be = Dwidth / width;
            } else {
                be = Dheight / height;
            }
        }

        if (be <= 0) {
            be = 1;
        }
        //设置缩放比例
        newOpts.inSampleSize = (int) be;
        //重新读入图片，注意此时已经把options.inJustDecodeBounds 设回false了
        bitmap = BitmapFactory.decodeFile(srcPath, newOpts);
        return compressImage(bitmap, rate);//压缩好比例大小后再进行质量压缩
    }

    private byte[] compressImage(Bitmap image, double rate) {

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        image.compress(Bitmap.CompressFormat.JPEG, (int) (100 * rate), baos);//质量压缩方法，这里100表示不压缩，把压缩后的数据存放到baos中
        return baos.toByteArray();
    }
}
