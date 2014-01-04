//
//  UWBEAppDelegate.h
//  mapTwitter
//
//  Created by Li Yansong on 13-12-28.
//  Copyright (c) 2013年 Liyansong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TwitterAPI;

@interface UWBEAppDelegate : UIResponder <UIApplicationDelegate>

+ (instancetype)sharedDelegate;

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) TwitterAPI *twitterAPI;

@end
