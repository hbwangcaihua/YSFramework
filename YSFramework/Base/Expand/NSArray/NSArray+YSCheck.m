//
//  NSArray+YSCheck.m
//  YSFramework
//
//  Created by qitmac000370 on 2018/12/4.
//  Copyright © 2018年 wch. All rights reserved.
//

#import "NSArray+YSCheck.h"

@implementation NSArray (YSCheck)

/**
 *  判断是否含有某字符串
 */
-(BOOL)isExistString:(NSString *)str{
    BOOL isExist = NO;
    for(NSString *item in self){
        if([[item lowercaseString] isEqualToString:[str lowercaseString]]){
            isExist = YES;
            break;
        }
    }
    return isExist;
}

@end
