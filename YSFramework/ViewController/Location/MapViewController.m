//
//  MapViewController.m
//  YSFramework
//
//  Created by qitmac000370 on 2018/12/6.
//  Copyright © 2018年 wch. All rights reserved.
//

#import "MapViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>

@interface MapViewController ()<MAMapViewDelegate>

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地图";
    
    [self operateMap];
}

- (void)operateMap{
    if([_key isEqualToString:@"showmap"]){
        ///初始化地图
        MAMapView *_mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        
        //是否支持缩放，默认为YES
//        _mapView.zoomEnabled = YES;
        _mapView.zoomLevel = 10;
        
        //logo位置, 必须在mapView.bounds之内，否则会被忽略
//        _mapView.logoCenter = CGPointMake(100, 100);
        
        //是否显示指南针
//        _mapView.showsCompass = YES;
//        _mapView.compassOrigin = CGPointMake(100, 100);
        
        //是否显示比例尺
//        _mapView.showsScale = YES;
//        _mapView.scaleOrigin = CGPointMake(100, 100);
        
        //中心位置定位
//        _mapView.centerCoordinate = CLLocationCoordinate2DMake(40.04642361, 116.35648899);
        
        //是否显示当前用户位置
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        
        
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.989631, 116.481018);
        pointAnnotation.title = @"方恒国际";
        pointAnnotation.subtitle = @"阜通东大街6号";
        
        [_mapView addAnnotation:pointAnnotation];
        
        ///把地图添加至view
        [self.view addSubview:_mapView];
    }
    else if([_key isEqualToString:@"customlocation"]){
        MAMapView *_mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_mapView];
        _mapView.zoomLevel = 10;
        _mapView.delegate = self;
        
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        
//        MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
//        r.showsAccuracyRing = YES;///精度圈是否显示，默认YES
//        r.showsHeadingIndicator = YES;///是否显示方向指示(MAUserTrackingModeFollowWithHeading模式开启)。默认为YES
//        r.fillColor = [UIColor redColor];///精度圈 填充颜色, 默认 kAccuracyCircleDefaultColor
//        r.strokeColor = [UIColor blueColor];///精度圈 边线颜色, 默认 kAccuracyCircleDefaultColor
//        r.lineWidth = 2;///精度圈 边线宽度，默认0
////        r.enablePulseAnnimation = NO;///内部蓝色圆点是否使用律动效果, 默认YES
////        r.locationDotBgColor = [UIColor greenColor];///定位点背景色，不设置默认白色
////        r.locationDotFillColor = [UIColor grayColor];///定位点蓝色圆点颜色，不设置默认蓝色
//        r.image = [UIImage imageNamed:@"icon_location.png"]; ///定位图标, 与蓝色原点互斥
//        [_mapView updateUserLocationRepresentation:r];


        
    }
}


- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"icon_location.png"];
//        self.userLocationAnnotationView = annotationView;
        return annotationView;
    }
    return nil;
}

@end
