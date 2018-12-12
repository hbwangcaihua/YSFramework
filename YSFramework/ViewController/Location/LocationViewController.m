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
4. Background Modes 中的 Location updates 处于选中状态
*/

#import "LocationViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "MapViewController.h"
#import "MapNearbyLocationViewController.h"

@interface LocationViewController ()<AMapLocationManagerDelegate>

@property(nonatomic,strong) CLLocationManager *clLocationManager;
@property(nonatomic,strong) AMapLocationManager *locationManager;
@property(nonatomic,strong) AMapGeoFenceManager *geoFenceManager;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    [self setUpInnerView];
}

- (void)setUpInnerView{
    
    //定位
    UIButton *locationBtn = [self createUIButtonWithFrame:CGRectMake(20, 150, 335, 50) title:@"单次定位" customTag:@"onetime_normal"];
    [self.view addSubview:locationBtn];
    
    UIButton *upBtn = [self createUIButtonWithFrame:CGRectMake(20, 220, 335, 50) title:@"后台定位" customTag:@"behind"];
    [self.view addSubview:upBtn];
    
    
    //地图
    UIButton *showMapBtn = [self createUIButtonWithFrame:CGRectMake(20, 330, 335, 50) title:@"显示地图" customTag:@"showmap"];
    [self.view addSubview:showMapBtn];
    UIButton *customLocationShowBtn = [self createUIButtonWithFrame:CGRectMake(20, 400, 335, 50) title:@"自定义小蓝点" customTag:@"customlocation"];
    [self.view addSubview:customLocationShowBtn];
    
    //示例
    UIButton *demoBtn = [self createUIButtonWithFrame:CGRectMake(20, 500, 335, 50) title:@"示例" customTag:@"demo"];
    [self.view addSubview:demoBtn];
    
    //地理围栏
    UIButton *geoBtn = [self createUIButtonWithFrame:CGRectMake(20, 570, 335, 50) title:@"围栏" customTag:@"geo"];
    [self.view addSubview:geoBtn];
    
}

- (void)commonBtnAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSString *key = objc_getAssociatedObject(btn, @"customtag");
    
    [self operateMap:key];
    [self operateLocation:key];
    
    if([key isEqualToString:@"demo"]){
        /* 点击“确定”按钮走的Block方法 */
        MapSelectPOIlocationsBlock poiBlock = ^(MAMapView *mapView, AMapPOI *poi){
            
            
        };
        
        MapNearbyLocationViewController *mapVc = [[MapNearbyLocationViewController alloc] init];
//        mapVc.mapSuccessPOIBlocks = poiBlock;
//        mapVc.mapLocationStyle = MapLocationStyleSelectSinglePOI;
//        mapVc.navTitle = @"选择";
////        mapVc.finescope = finescope;
//        mapVc.isContinuousPositioning = NO;
        [self.navigationController pushViewController:mapVc animated:YES];
    }
}

#pragma mark - 地图

- (void)operateMap:(NSString *)key{
    if([key isEqualToString:@"showmap"]){
        MapViewController *mapVC = [[MapViewController alloc] init];
        mapVC.key = key;
        [self.navigationController pushViewController:mapVC animated:YES];
    }
}

#pragma mark - 定位

- (void)operateLocation:(NSString *)key{
    if([key isEqualToString:@"onetime_normal"]){
        //需要高精度时使用kCLLocationAccuracyBest，超时设定为10s
        // 带逆地理信息的一次定位（返回坐标和地址信息）
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        //   定位超时时间，最低2s，此处设置为2s
        self.locationManager.locationTimeout =2;
        //   逆地理请求超时时间，最低2s，此处设置为2s
        self.locationManager.reGeocodeTimeout = 2;
        
        // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
        [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
            if (error)
            {
                NSLog(@"wch----------locError:{%ld - %@};", (long)error.code, error.localizedDescription);
                
                if (error.code == AMapLocationErrorLocateFailed)
                {
                    return;
                }
            }
            
            NSLog(@"wch----------location:%@", location);
            
            if (regeocode)
            {
                NSLog(@"wch----------reGeocode:%@", regeocode);
            }
        }];
    }
    else if ([key isEqualToString:@"behind"]){
        //设置定位最小更新距离。（不设定时，每6秒更新一次）
        //        self.locationManager.distanceFilter = 200;
        //后台定位是否返回逆地理信息，默认NO。
        self.locationManager.locatingWithReGeocode = YES;
        //是否允许后台定位，默认NO。(Background Modes 中的 Location updates 处于选中状态，否则会抛出异常)。开启后，用户选择“使用应用期间”会出现蓝条
        self.locationManager.allowsBackgroundLocationUpdates = YES;
        
        //开始连续定位。
        [self.locationManager startUpdatingLocation];
        
        
    } else if( [key isEqualToString:@"geo"]){
//        self.locationManager.locatingWithReGeocode = YES;
//        self.locationManager.allowsBackgroundLocationUpdates = YES;
//        [self.locationManager startUpdatingLocation];
        
        //初始化地理围栏
        self.geoFenceManager = [[AMapGeoFenceManager alloc] init];
        self.geoFenceManager.delegate = self;
        self.geoFenceManager.activeAction = AMapGeoFenceActiveActionInside | AMapGeoFenceActiveActionOutside | AMapGeoFenceActiveActionStayed; //设置希望侦测的围栏触发行为，默认是侦测用户进入围栏的行为，即AMapGeoFenceActiveActionInside，这边设置为进入，离开，停留（在围栏内10分钟以上），都触发回调
        self.geoFenceManager.allowsBackgroundLocationUpdates = YES;  //允许后台定位
        
        //创建自定义原型围栏
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(40.046410, 116.356498);
        [self.geoFenceManager addCircleRegionForMonitoringWithCenter:coordinate radius:300 customID:@"circle_1"];
    }
}

//接收位置更新,实现AMapLocationManagerDelegate代理的amapLocationManager:didUpdateLocation方法，处理位置更新
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    NSLog(@"wch-----location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    if (reGeocode)
    {
        NSLog(@"wch------reGeocode:%@", reGeocode);
    }
}

//1、获取围栏创建后的回调
- (void)amapGeoFenceManager:(AMapGeoFenceManager *)manager didAddRegionForMonitoringFinished:(NSArray<AMapGeoFenceRegion *> *)regions customID:(NSString *)customID error:(NSError *)error {
    if (error) {
        NSLog(@"wch----------创建失败 %@",error);
    } else {
        NSLog(@"wch----------创建成功");
    }
}
//2、围栏状态改变时的回调
- (void)amapGeoFenceManager:(AMapGeoFenceManager *)manager didGeoFencesStatusChangedForRegion:(AMapGeoFenceRegion *)region customID:(NSString *)customID error:(NSError *)error {
    if (error) {
        NSLog(@"wch----------status changed error %@",error);
    }else{
        NSLog(@"wch----------status changed success %@",[region description]);
    }
}


@end
