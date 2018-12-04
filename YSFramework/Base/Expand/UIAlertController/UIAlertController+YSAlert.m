//
//  UIAlertController+YSAlert.m
//  YSFramework
//
//  Created by qitmac000370 on 2018/12/4.
//  Copyright © 2018年 wch. All rights reserved.
//

#import "UIAlertController+YSAlert.h"

@implementation UIAlertController (YSAlert)

/**
  显示弹窗消息
 */
+(void)alertWithMessage:(NSString *)message controller:(UIViewController*)controller{
    [self alertWithTitle:@"提示" message:message controller:controller];
}

/**
 显示弹窗消息
 */
+(void)alertWithTitle:(NSString *)title message:(NSString *)message controller:(UIViewController*)controller{
    [self alertWithTitle:title message:message cancle:@"好" controller:controller];
}

/**
 显示弹窗消息
 */
+(void)alertWithTitle:(NSString *)title message:(NSString *)message cancle:(NSString *)cancle controller:(UIViewController*)controller{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:cancle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:okAction];
    
    [controller presentViewController:alertController animated:YES completion:^{
    } ];
}

@end
