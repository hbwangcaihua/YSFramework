//
//  UIColor+YSTurnRGB.m
//  YSFramework
//
//  Created by qitmac000370 on 2018/12/4.
//  Copyright © 2018年 wch. All rights reserved.
//

#import "UIColor+YSTurnRGB.h"

@implementation UIColor (YSTurnRGB)

/**
 *  将字符串转换为UIColor
 */
+(UIColor *)turnStringToRGB:(NSString *)stringColor{
    NSRange range;
    range.location = 1;
    range.length = 2;
    NSString *rString = [stringColor substringWithRange:range];
    
    range.location = 3;
    NSString *gString = [stringColor substringWithRange:range];
    
    range.location = 5;
    NSString *bString = [stringColor substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    UIColor *color  = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    
    return color;
}

@end
