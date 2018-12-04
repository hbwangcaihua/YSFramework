//
//  BaseViewController.h
//  YSFramework
//
//  Created by qitmac000370 on 2018/12/4.
//  Copyright © 2018年 wch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface BaseViewController : UIViewController

-(UIButton *)createUIButtonWithFrame:(CGRect)frame title:(NSString *)title customTag:(NSString *)tag;

@end
