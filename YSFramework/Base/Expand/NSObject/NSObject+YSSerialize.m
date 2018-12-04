//
//  NSObject+YSSerialize.m
//  YSFramework
//
//  Created by qitmac000370 on 2018/12/4.
//  Copyright © 2018年 wch. All rights reserved.
//

#import "NSObject+YSSerialize.h"
#import <objc/runtime.h>
#import "NSDictionary+YSSerialize.h"

@implementation NSObject (YSSerialize)

#pragma mark - Serialize

/**
 模型转字典
 */
-(NSMutableDictionary *)seriaObjToDic
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    for (NSString *key in [self propertyKeys]) {
        id propertyValue = [self valueForKey:key];
        //该值不为NSNULL，并且也不为nil
        if(propertyValue!=nil){
            [dic setObject:propertyValue forKey:key];
        } else {
            [dic setObject:@"" forKey:key];
        }
    }
    return dic;
}

/**
 模型转字符串
 */
-(NSString *)seriaObjToString{
    NSMutableDictionary *dic = [self seriaObjToDic];
    return [dic seriaDicToString];
}

#pragma mark - Helper

/**
 获取对象的属性
 */
- (NSArray*)propertyKeys
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    NSMutableArray *propertys = [NSMutableArray arrayWithCapacity:outCount];
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [propertys addObject:propertyName];
    }
    free(properties);
    return propertys;
}

@end
