//
//  UIColor+Additions.h
//  mapTwitter
//
//  Created by Li Yansong on 14-1-3.
//  Copyright (c) 2014年 Liyansong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Additions)

+ (UIColor *) colorWithDesignIndex:(int)index;
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;

@end
