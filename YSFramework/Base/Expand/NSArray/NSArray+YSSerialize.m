//
//  NSArray+YSSerialize.m
//  YSFramework
//
//  Created by qitmac000370 on 2018/12/4.
//  Copyright © 2018年 wch. All rights reserved.
//

#import "NSArray+YSSerialize.h"

@implementation NSArray (YSSerialize)

/**
 *  转换为字符串
 */
-(NSString *)seriaArrToString{
    NSData *postDatas = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:postDatas encoding:NSUTF8StringEncoding];
    return str;
}

@end
