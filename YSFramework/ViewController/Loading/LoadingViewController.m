//
//  LoadingViewController.m
//  YSFramework
//
//  Created by qitmac000370 on 2018/12/3.
//  Copyright © 2018年 wch. All rights reserved.
//

#import "LoadingViewController.h"

@interface LoadingViewController()

@property(nonatomic,assign) int times;
@property(nonatomic,strong) UIImageView *roundImageView;

@end

@implementation LoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"加载中";
    
    //马路
    UIView *outerView = [[UIView alloc] initWithFrame:CGRectMake(140, 240, 80, 22)];
    outerView.backgroundColor = [UIColor clearColor];
    outerView.clipsToBounds = YES;
    [self.view addSubview:outerView];
    
    _roundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 204, 22)];
    _roundImageView.contentMode = UIViewContentModeScaleAspectFill;
    _roundImageView.image = [UIImage imageNamed:@"LoadingCamelBG.png"];
    [outerView addSubview:_roundImageView];
    [self test];
    
    //小骆驼
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(140, 200, 80, 80)];
    logoImageView.contentMode = UIViewContentModeScaleToFill;
    logoImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:logoImageView];
    
    UIImage *image = [UIImage imageNamed:@"LoadingCamel_000.png"];
    _times = 0;
    if (@available(iOS 10.0, *)) {
        __weak typeof(self) weakSelf = self;
        [NSTimer scheduledTimerWithTimeInterval:0.03 repeats:YES block:^(NSTimer * _Nonnull timer) {
            CGRect rect = CGRectMake(160*weakSelf.times, 0, 160, 160);//创建矩形框
            logoImageView.image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage], rect)];
            weakSelf.times += 1;
            if(weakSelf.times == 8 ){
                weakSelf.times = 0;
            }
        }];
    } else {
        // Fallback on earlier versions
    }
}

-(void)test{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        weakSelf.roundImageView.frame = CGRectMake(80-204, 0, 204, 22);//创建矩形框
    } completion:^(BOOL finished) {
        weakSelf.roundImageView.frame = CGRectMake(-22, 0, 204, 22);//创建矩形框
        [weakSelf test];
    }];
}

@end
