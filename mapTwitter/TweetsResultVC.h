//
//  TweetsResultVC.h
//  mapTwitter
//
//  Created by Li Yansong on 14-1-2.
//  Copyright (c) 2014年 Liyansong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface TweetsResultVC : UITableViewController <SWTableViewCellDelegate>

@property (nonatomic, copy) NSString *query;
@property (nonatomic, copy) NSString *locationString;
@property (nonatomic, copy) NSString *searchLocStr;

@end
