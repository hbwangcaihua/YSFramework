//
//  NSData+YSBase64.h
//  YSFramework
//
//  Created by qitmac000370 on 2018/12/3.
//  Copyright © 2018年 wch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (YSBase64)

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;

@end
