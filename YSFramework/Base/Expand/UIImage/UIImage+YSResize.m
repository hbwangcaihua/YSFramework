//
//  UIImage+YSResize.m
//  YSFramework
//
//  Created by qitmac000370 on 2018/12/4.
//  Copyright © 2018年 wch. All rights reserved.
//

#import "UIImage+YSResize.h"

@implementation UIImage (YSResize)

/**
  等比例压缩图片到指定大小
 */
- (UIImage *)compressScaleToSize:(CGSize)size
{
    CGFloat width  = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    CGFloat scale = MIN(size.width / width, size.height / height);
    width  = width * scale;
    height = height * scale;
    int xPos = (size.width - width)/2;
    int yPos = (size.height - height)/2;
    UIGraphicsBeginImageContextWithOptions(size, NO,[[UIScreen mainScreen] scale]);
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

/**
 等比例压缩图片到指定大小
 */
- (UIImage *)compressScaleWithWidth:(float)width height:(float)height
{
    if (width>self.size.width && height > self.size.height)
    {
        return self;
    }
    else
    {
        float iw = self.size.width;
        float ih = self.size.height;
        float iLw = iw;
        float iLh = ih;
        if (height < ih || width < iw)
        {
            if ((float)height / (float)ih < (float)width / (float)iw)
            {
                iLh = height;
                iLw = iLh * iw / ih;
            }
            else
            {
                iLw = width;
                iLh = iLw * ih / iw;
            }
        }
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(iLw, iLh), NO, 0);
        [self drawInRect:CGRectMake(0, 0, iLw, iLh)];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return scaledImage;
    }
}

/**
  压缩图片到指定大小
 */
-(UIImage*)compressToSize:(CGSize)size
{
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

@end
