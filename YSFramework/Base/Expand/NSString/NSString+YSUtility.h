//
//  NSString+YSUtility.h
//  YSFramework
//
//  Created by qitmac000370 on 2018/12/3.
//  Copyright © 2018年 wch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (YSUtility)

#pragma mark - Class method

/**
 *  转换为容量字符串
 */
+ (NSString *)transToCapacity:(long long)value;

#pragma mark - Instance method

/**
 *  计算当前字符串的尺寸大小
 */
-(CGSize)sizeWithMaxSize:(CGSize)maxSize font:(UIFont *)font;

/**
 *  计算当前字符串的尺寸大小
 */
-(CGSize)sizeWithMaxSize:(CGSize)maxSize font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode;

/**
 *  md5加密
 */
- (NSString *)md5Hash;

/**
 *  忽略大小写的字符串替换
 */
-(NSString *)stringByReplacingIgnoreOccurrencesOfString:(NSString *)forReplace withString:(NSString *)toRelace;

/**
 *  截取字符串
 */
- (NSString *)subStringFrom:(NSString *)startString to:(NSString *)endString;

@end
