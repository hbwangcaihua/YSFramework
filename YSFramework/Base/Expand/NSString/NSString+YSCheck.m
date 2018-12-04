//
//  NSString+YSCheck.m
//  YSFramework
//
//  Created by qitmac000370 on 2018/12/3.
//  Copyright © 2018年 wch. All rights reserved.
//

#import "NSString+YSCheck.h"

@implementation NSString (YSCheck)

#pragma mark - Class method

/**
 *  给定的字符串是否是nil或者空字符串
 */
+(BOOL)isNullOrEmpty:(NSString *)str{
    id tmpValue=str;
    if([NSNull null]==tmpValue) return YES;
    if(![str isKindOfClass:[NSString class]]) return YES;
    if(str==nil)return YES;
    if([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0) return YES;
    return [@"" isEqualToString:str];
}

#pragma mark - Instance method

/**
 *  判断是否是纯汉字
 */
- (BOOL)isChinese
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

/**
 *  判断是否含有汉字
 */
- (BOOL)includeChinese
{
    for(int i=0; i< [self length];i++)
    {
        int a =[self characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}

@end
