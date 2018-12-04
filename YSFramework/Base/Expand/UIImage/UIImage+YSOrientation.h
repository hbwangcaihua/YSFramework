//
//  UIImage+YSOrientation.h
//  YSFramework
//
//  Created by qitmac000370 on 2018/12/4.
//  Copyright © 2018年 wch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YSOrientation)

/**
 纠正图片方向
 */
+ (UIImage *)fixOrientation:(UIImage *)image;

@end
