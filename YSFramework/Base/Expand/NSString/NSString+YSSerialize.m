//
//  NSString+YSSerialize.m
//  YSFramework
//
//  Created by qitmac000370 on 2018/12/4.
//  Copyright © 2018年 wch. All rights reserved.
//

#import "NSString+YSSerialize.h"
#import "NSDictionary+YSSerialize.h"

@implementation NSString (YSSerialize)

/**
 *  字符串转字典
 */
- (NSDictionary *)seriaStringToDic{
    if(self == nil){
        return [[NSDictionary alloc] init];;
    }
    
    NSDictionary *dataSource = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                                               options:NSJSONReadingMutableLeaves
                                                                 error:nil];
    return dataSource;
}

/**
 *  字符串转对象
 */
- (void)seriaStringToObj:(NSObject *)obj{
    NSDictionary *dic = [self seriaStringToDic];
    [dic seriaDicToObj:obj];
}

/**
 *  字符串转数组
 */
- (NSMutableArray *)seriaStringToArr{
    if(self == nil){
        return [NSMutableArray array];
    }
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    // 将JSON串转化为字典或者数组
    NSError *error = nil;
    NSMutableArray *chatUsers = [NSMutableArray array];
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                          options:NSJSONReadingAllowFragments
                                                            error:&error];
    [chatUsers addObjectsFromArray:jsonObject];
    
    return chatUsers;
}

@end
