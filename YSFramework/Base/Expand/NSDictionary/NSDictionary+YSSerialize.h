//
//  NSDictionary+YSSerialize.h
//  YSFramework
//
//  Created by qitmac000370 on 2018/12/4.
//  Copyright © 2018年 wch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (YSSerialize)

/**
 *  转换为字符串
 */
-(NSString *)seriaDicToString;

/**
 *  转换为对象
 */
- (void)seriaDicToObj:(NSObject *)obj;

@end
