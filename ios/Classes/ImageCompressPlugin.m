#import "ImageCompressPlugin.h"

@implementation ImageCompressPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"image_compress"
            binaryMessenger:[registrar messenger]];
  ImageCompressPlugin* instance = [[ImageCompressPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"compressImage" isEqualToString:call.method]) {
              NSString *path = call.arguments[@"path"];
               NSString *rate = call.arguments[@"rate"];
               NSString *width = call.arguments[@"width"];
               NSString *height = call.arguments[@"height"];
              CGFloat rateFloat = [rate doubleValue];
              CGFloat widthFloat = [width doubleValue];
              CGFloat heightFloat = [height doubleValue];
              UIImage *imgFromPath=[[UIImage alloc]initWithContentsOfFile:path];
              NSData *data = [self ImageCompressInvoke:imgFromPath :rateFloat :widthFloat :heightFloat];
              result([FlutterStandardTypedData typedDataWithBytes:data]);
          } else {
              result(FlutterMethodNotImplemented);
          }
}

-(NSData *)ImageCompressInvoke: (UIImage *)imageCompresSource : (CGFloat)rateFloat :(CGFloat )width :(CGFloat )height{
    if (width == 0.0 || height == 0.0) {
        CGSize imageSize = imageCompresSource.size;
         width = imageSize.width;    //图片宽度
         height = imageSize.height;  //图片高度
        //1.宽高大于1280(宽高比不按照2来算，按照1来算)
        if (width>1280||height>1280) {
            if (width>height) {
                CGFloat scale = height/width;
                width = 1280;
                height = width*scale;
            }else{
                CGFloat scale = width/height;
                height = 1280;
                width = height*scale;
            }
            //2.宽大于1280高小于1280
        }else if(width>1280||height<1280){
            CGFloat scale = height/width;
            width = 1280;
            height = width*scale;
            //3.宽小于1280高大于1280
        }else if(width<1280||height>1280){
            CGFloat scale = width/height;
            height = 1280;
            width = height*scale;
            //4.宽高都小于1280
        }else{
        }
    }


    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [imageCompresSource drawInRect:CGRectMake(0,0,width,height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    //进行图像的画面质量压缩
    NSData *data=UIImageJPEGRepresentation(newImage, 1.0);
    if (rateFloat == 0 || data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(newImage, 0.7);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(newImage, 0.8);
        }else if (data.length>200*1024) {
            //0.25M-0.5M
            data=UIImageJPEGRepresentation(newImage, 0.9);
        }
    }else if(rateFloat != 0){
        data =UIImageJPEGRepresentation(newImage, rateFloat);
    }
    return data;
}

@end
