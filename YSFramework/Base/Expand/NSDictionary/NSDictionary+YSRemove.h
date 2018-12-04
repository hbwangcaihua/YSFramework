//
//  NSDictionary+YSRemove.h
//  YSFramework
//
//  Created by qitmac000370 on 2018/12/4.
//  Copyright © 2018年 wch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (YSRemove)

/**
 *  移除不可用的key，序列化时使用。如:value为block
 */
+(NSDictionary *)removeUnabelKey:(NSDictionary *)dic;

/**
 *  移除值为null的key,存储数据时使用
 */
+ (id) removeJsonNullFromDic:(id)obj;

@end
