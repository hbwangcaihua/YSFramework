//
//  NSString+YSSerialize.h
//  YSFramework
//
//  Created by qitmac000370 on 2018/12/4.
//  Copyright © 2018年 wch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YSSerialize)

/**
 *  字符串转字典
 */
- (NSDictionary *)seriaStringToDic;

/**
 *  字符串转对象
 */
- (void)seriaStringToObj:(NSObject *)obj;

/**
 *  字符串转数组
 */
- (NSMutableArray *)seriaStringToArr;

@end
