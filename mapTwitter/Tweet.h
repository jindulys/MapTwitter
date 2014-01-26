//
//  Tweet.h
//  mapTwitter
//
//  Created by Li Yansong on 14-1-3.
//  Copyright (c) 2014年 Liyansong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *profileImageURL;
@property (nonatomic) CGFloat desiredHeight;
@property (nonatomic) CGFloat contentHeight;
@property (nonatomic) CGFloat nameHeight;

@end
