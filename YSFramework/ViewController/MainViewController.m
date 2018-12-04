//
//  MainViewController.m
//  YSFramework
//
//  Created by qitmac000370 on 2018/12/3.
//  Copyright © 2018年 wch. All rights reserved.
//

#import "MainViewController.h"
#import "LoadingViewController.h"
#import "LocationViewController.h"

@interface MainViewController (){
    int times;
    UIImageView *roundImageView;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"主页";
    
    [self setUpInnerView];
}

- (void)setUpInnerView{
    UIButton *locationBtn = [self createUIButtonWithFrame:CGRectMake(20, 150, 335, 50) title:@"地图" customTag:@"location"];
    [self.view addSubview:locationBtn];
}

- (void)commonBtnAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSString *key = objc_getAssociatedObject(btn, @"customtag");
    
    if([key isEqualToString:@"location"]){
        LocationViewController *locationVC = [[LocationViewController alloc] init];
        [self.navigationController pushViewController:locationVC animated:YES];
    }
}

@end
