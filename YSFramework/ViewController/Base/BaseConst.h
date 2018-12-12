//
//  BaseConst.h
//  YSFramework
//
//  Created by qitmac000370 on 2018/12/4.
//  Copyright © 2018年 wch. All rights reserved.
//

#ifndef BaseConst_h
#define BaseConst_h

#endif /* BaseConst_h */


#define Location_GaoDeKey @"e501d2610b64581e076efde5bb9273ec"

#define YS_SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define YS_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define YS_IPHONEX ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812)

/* 状态栏高度(20) */
#define YS_STATUS_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height

/* 状态栏高度超过20<##> 开热点时*/
#define STATUS_BAR_BIGGER_THAN_20 [UIApplication sharedApplication].statusBarFrame.size.height > 20

/* 状态栏和导航栏高度(64) */
#define YS_STATUS_NAV_HEIGHT ([[UIApplication sharedApplication] statusBarFrame].size.height+self.navigationController.navigationBar.frame.size.height)
