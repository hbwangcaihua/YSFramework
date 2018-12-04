//
//  NSMutableDictionary+YSSafe.m
//  YSFramework
//
//  Created by qitmac000370 on 2018/12/4.
//  Copyright © 2018年 wch. All rights reserved.
//

#import "NSMutableDictionary+YSSafe.h"
#import "NSString+YSCheck.h"

@implementation NSMutableDictionary (YSSafe)

/**
 *  不可变字典
 */
-(NSDictionary *)ysNSDictonaryForKey:(NSString *)key{
    id data = [self objectForKey:key];
    if([data isKindOfClass:[NSDictionary class]]) {
        return data;
    }
    return [[NSDictionary alloc] init];
}

/**
 *  可变字典
 */
-(NSMutableDictionary *)ysNSMutableDictionaryForKey:(NSString *)key{
    id data = [self objectForKey:key];
    if([data isKindOfClass:[NSDictionary class]]) {
        return [[NSMutableDictionary alloc] initWithDictionary:data];
    }
    return [[NSMutableDictionary alloc] init];
}

/**
 *  不可变数组
 */
-(NSArray *)ysNSArrayForKey:(NSString *)key{
    id data = [self objectForKey:key];
    if([data isKindOfClass:[NSArray class]]) {
        return data;
    }
    return [[NSArray alloc] init];
}

/**
 *  可变数组
 */
-(NSMutableArray *)ysNSMutableArrayForKey:(NSString *)key{
    id data = [self objectForKey:key];
    if([data isKindOfClass:[NSArray class]]) {
        return [NSMutableArray arrayWithArray:data];
    }
    return [[NSMutableArray alloc] init];
}

/**
 *  字符串
 */
-(NSString *)ysNSStringForKey:(NSString *)key{
    id data = [self objectForKey:key];
    if([data isKindOfClass:[NSString class]]) {
        if([NSString isNullOrEmpty:((NSString *)data)]){
            return @"";
        }
        return data;
    }
    return @"";
}

/**
 *  数值型
 */
-(NSNumber *)ysNSNumberForKey:(NSString *)key{
    id data = [self objectForKey:key];
    if([data isKindOfClass:[NSNumber class]]) {
        return data;
    }
    return [NSNumber numberWithInteger:0];
}

@end
