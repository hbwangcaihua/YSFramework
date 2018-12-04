//
//  NSObject+YSSerialize.h
//  YSFramework
//
//  Created by qitmac000370 on 2018/12/4.
//  Copyright © 2018年 wch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (YSSerialize)

#pragma mark - Serialize

/**
 模型转字典
 */
-(NSMutableDictionary *)seriaObjToDic;

/**
 模型转字符串
 */
-(NSString *)seriaObjToString;

#pragma mark - Helper

/**
 获取对象的属性
 */
- (NSArray*)propertyKeys;

@end
