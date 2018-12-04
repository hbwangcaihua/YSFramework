//
//  LocationViewController.m
//  YSFramework
//
//  Created by qitmac000370 on 2018/12/4.
//  Copyright © 2018年 wch. All rights reserved.
//

/*
使用方法：
1. 添加pod：  pod 'AMapLocation'
2. 获取高德key
3. 在info.plist中添加定位权限申请（在plist文件中同时添加NSLocationWhenInUseUsageDescription、NSLocationAlwaysUsageDescription和NSLocationAlwaysAndWhenInUseUsageDescription权限申请）
*/

#import "LocationViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>

@interface LocationViewController ()<AMapLocationManagerDelegate>

@property(nonatomic,strong) AMapLocationManager *locationManager;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;

    [self.locationManager startUpdatingLocation];
}

//接收位置更新,实现AMapLocationManagerDelegate代理的amapLocationManager:didUpdateLocation方法，处理位置更新
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    if (reGeocode)
    {
        NSLog(@"reGeocode:%@", reGeocode);
    }
}


@end
