//
//  TweetsResultCell.m
//  mapTwitter
//
//  Created by Li Yansong on 14-1-2.
//  Copyright (c) 2014年 Liyansong. All rights reserved.
//

#import "TweetsResultCell.h"

@implementation TweetsResultCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithData:(id)data {
    // TODO: Temporary data
    NSDictionary *dic = (NSDictionary *)data;
    self.textLabel.text = dic[@"name"];
    self.detailTextLabel.text = dic[@"text"];
}

@end
