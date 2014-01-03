//
//  TweetsResultCell.h
//  mapTwitter
//
//  Created by Li Yansong on 14-1-2.
//  Copyright (c) 2014年 Liyansong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetsResultCell : UITableViewCell

@property (strong, nonatomic) UILabel *userNameLabel;
@property (strong, nonatomic) UILabel *discriptionLabel;

- (void)configureWithData:(id)data;

@end
