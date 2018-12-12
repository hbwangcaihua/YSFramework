//
//  MapNearbyLocationViewController.h
//  YSFramework
//
//  Created by qitmac000370 on 2018/12/10.
//  Copyright © 2018年 wch. All rights reserved.
//

#import "BaseViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

/**
 *  地图定位选择类型
 */
typedef enum{
    /**
     *  正常模式 [可以选择任何位置]
     */
    MapLocationStyleDefault=0,
    /**
     *  单选模式 [只允许选择当前位置]
     */
    MapLocationStyleSelectSingle,
    /**
     *  返回当前位置附近信息  [只允许选择附近位置]
     */
    MapLocationStyleSelectSinglePOI,
}MapLocationStyle;

typedef void (^MapSelectPOIlocationsBlock)(MAMapView *mapView, AMapPOI *poi);



@interface MapNearbyLocationViewController : BaseViewController


/* 选择位置后，右上角确定按钮操作 */
@property (nonatomic,copy)   MapSelectPOIlocationsBlock   mapSuccessPOIBlocks;

/** 地图相关*/
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapLocationManager *locationManager;

/**
 *  搜索框
 */
@property (nonatomic, strong) UISearchBar *aSearchBar;
@property (nonatomic,strong) UITableView *tableView;
/* 是否可以点击地图 */
@property (nonatomic)BOOL isClickOnMAMapView;
/* 导航栏标题 */
@property (nonatomic, strong) NSString *navTitle;
/* 微调范围 */
@property (nonatomic, assign) NSInteger finescope;

@property (assign, nonatomic) MapLocationStyle mapLocationStyle;

@property (nonatomic) BOOL isContinuousPositioning; // 1 开启持续定位

@end
