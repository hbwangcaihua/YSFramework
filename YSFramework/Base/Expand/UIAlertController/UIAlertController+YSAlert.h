//
//  UIAlertController+YSAlert.h
//  YSFramework
//
//  Created by qitmac000370 on 2018/12/4.
//  Copyright © 2018年 wch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (YSAlert)

/**
 显示弹窗消息
 */
+(void)alertWithMessage:(NSString *)message controller:(UIViewController*)controller;

/**
 显示弹窗消息
 */
+(void)alertWithTitle:(NSString *)title message:(NSString *)message controller:(UIViewController*)controller;

/**
 显示弹窗消息
 */
+(void)alertWithTitle:(NSString *)title message:(NSString *)message cancle:(NSString *)cancle controller:(UIViewController*)controller;

@end
