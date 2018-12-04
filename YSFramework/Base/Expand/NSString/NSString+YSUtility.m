//
//  NSString+YSUtility.m
//  YSFramework
//
//  Created by qitmac000370 on 2018/12/3.
//  Copyright © 2018年 wch. All rights reserved.
//

#import "NSString+YSUtility.h"
#import <CommonCrypto/CommonCrypto.h>
#import "NSString+YSCheck.h"

@implementation NSString (YSUtility)

#pragma mark - Class method

/**
 *  转换为容量字符串
 */
+ (NSString *)transToCapacity:(long long)value{
    double convertedValue = value;
    int multiplyFactor = 0;
    
    NSArray *tokens = [NSArray arrayWithObjects:@"B", @"KB", @"MB", @"GB", @"TB", nil];
    
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%4.2f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];
}

#pragma mark - Instance method

/**
 *  计算当前字符串的尺寸大小
 */
-(CGSize)sizeWithMaxSize:(CGSize)maxSize font:(UIFont *)font{
    CGRect tmpRect=[self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return tmpRect.size;
}

/**
 *  计算当前字符串的尺寸大小
 */
-(CGSize)sizeWithMaxSize:(CGSize)maxSize font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode{
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGSize boundingBox = [self boundingRectWithSize:maxSize options: NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    CGSize size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    return size;
}

/**
 *  md5加密
 */
- (NSString *)md5Hash{
    if(self.length == 0) {
        return nil;
    }
    
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
}

/**
 *  忽略大小写的字符串替换
 */
-(NSString *)stringByReplacingIgnoreOccurrencesOfString:(NSString *)forReplace withString:(NSString *)toRelace{
    if([NSString isNullOrEmpty:toRelace]){
        toRelace = @"";
    }
    
    NSMutableString *afterReplace = [NSMutableString stringWithString:self];
    NSRange range = [[afterReplace lowercaseString]rangeOfString:forReplace];
    if (range.location != NSNotFound) {
        [afterReplace replaceCharactersInRange:range withString:toRelace];
    }
    return afterReplace;
}


/**
 *  截取字符串
 */
- (NSString *)subStringFrom:(NSString *)startString to:(NSString *)endString{
    NSRange startRange = [self rangeOfString:startString];
    NSRange endRange = [self rangeOfString:endString];
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    return [self substringWithRange:range];
}


@end
