//
//  SelectLocationCell.m
//  AppTemplateForNormal
//
//  Created by crw on 11/3/15.
//  Copyright © 2015 ZQ. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-2-20
 Version: 1.0
 Description: 【POI附件所有位置显示Cell】
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "SelectLocationCell.h"

@implementation SelectLocationCell

- (id)initWithMapStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
       self.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
       self.selectionStyle                = UITableViewCellSelectionStyleNone;
       self.textLabel.font                = [UIFont systemFontOfSize:16];
       self.detailTextLabel.font          = [UIFont systemFontOfSize:12];
       self.detailTextLabel.textColor     = [UIColor lightGrayColor];
    }
    return self;
}

@end
