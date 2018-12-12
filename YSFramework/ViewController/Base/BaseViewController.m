//
//  BaseViewController.m
//  YSFramework
//
//  Created by qitmac000370 on 2018/12/4.
//  Copyright © 2018年 wch. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - helper

-(UIButton *)createUIButtonWithFrame:(CGRect)frame title:(NSString *)title customTag:(NSString *)tag{
    UIButton *commonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commonBtn.frame = frame;
    
    [commonBtn.layer setBorderColor:CGColorCreate(CGColorSpaceCreateDeviceRGB(),(CGFloat[]){ 0, 1, 0, 1 })];
    [commonBtn.layer setBorderWidth:1];
    [commonBtn.layer setCornerRadius:5];
    
    [commonBtn setTitle:title forState:UIControlStateNormal];
    [commonBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    objc_setAssociatedObject(commonBtn, @"customtag", tag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [commonBtn addTarget:self action:@selector(commonBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return commonBtn;
}

- (void)commonBtnAction:(id)sender{
}

@end
