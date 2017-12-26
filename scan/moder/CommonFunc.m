//
//  CommonFunc.m
//  scan
//
//  Created by 陈鑫荣 on 2017/12/24.
//  Copyright © 2017年 justprint. All rights reserved.
//

#import "CommonFunc.h"

@implementation CommonFunc

+(UIImage *)createQRForString:(NSString *)qrString{

    CommonFunc*func=[[CommonFunc alloc]init];
    return [func createQRForString:qrString];
}
- (UIImage *)createQRForString:(NSString *)qrString
{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:stringData forKey:@"inputMessage"];
    CIImage *ciImage = [filter outputImage];
    //创建高清二维码
    UIImage *image = [self creatImage:ciImage size:300];
    //头像图片
    //  UIImage *icon = [UIImage imageNamed:@"头像图片"];
    //在二维码中间加入头像
  //  UIImage *newImage = [self creatImageIcon:image icon:nil];
    return image;
}
- (UIImage *)creatImage:(CIImage *)imgae size:(CGFloat )size
{
    CGRect extent = CGRectIntegral(imgae.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:imgae fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
- (UIImage *)creatImageIcon:(UIImage *)bgImage icon:(UIImage *)iconImage
{
    UIGraphicsBeginImageContext(bgImage.size);
    [bgImage drawInRect:(CGRectMake(0, 0, bgImage.size.width, bgImage.size.height))];
    CGFloat width = 20;
    CGFloat height = width;
    CGFloat x = (bgImage.size.width - width) * 0.5;
    CGFloat y = (bgImage.size.height - height) * 0.5;
    [iconImage drawInRect:(CGRectMake(x, y, width, height))];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
