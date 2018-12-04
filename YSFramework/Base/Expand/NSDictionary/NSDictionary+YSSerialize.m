//
//  NSDictionary+YSSerialize.m
//  YSFramework
//
//  Created by qitmac000370 on 2018/12/4.
//  Copyright © 2018年 wch. All rights reserved.
//

#import "NSDictionary+YSSerialize.h"
#import "NSDictionary+YSRemove.h"
#import "NSObject+YSSerialize.h"

@implementation NSDictionary (YSSerialize)

/**
 *  转换为字符串
 */
-(NSString *)seriaDicToString{
    
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:self];
    
    /* 如果内部还是字典，递归调用 */
    NSDictionary *dic = [NSDictionary removeUnabelKey:mutableDic];
    
    NSData *postDatas = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:postDatas encoding:NSUTF8StringEncoding];
    return str;
}

/**
 *  转换为对象
 */
- (void)seriaDicToObj:(NSObject *)obj
{
    for (NSString *key in [self allKeys]) {
        if ([[obj propertyKeys] containsObject:key]) {
            id propertyValue = [self valueForKey:key];
            if (![propertyValue isKindOfClass:[NSNull class]]
                && propertyValue != nil) {
                [obj setValue:propertyValue
                       forKey:key];
            }
        }
    }
}

@end
