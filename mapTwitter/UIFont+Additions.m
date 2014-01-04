//
//  UIFont+Additions.m
//  mapTwitter
//
//  Created by Li Yansong on 14-1-3.
//  Copyright (c) 2014年 Liyansong. All rights reserved.
//

#import "UIFont+Additions.h"

@implementation UIFont (Additions)

+ (UIFont *) YSSystemFontOfSize:(CGFloat)size {
    static NSMutableDictionary *fontContainer = nil;
    if (fontContainer == nil) {
        fontContainer = [[NSMutableDictionary alloc] init];
    }
    
    UIFont *font = [fontContainer objectForKey:[NSNumber numberWithFloat:size]];
    if (font == nil) {
        font = [UIFont systemFontOfSize:size];
        [fontContainer setObject:font forKey:[NSNumber numberWithFloat:size]];
    }
    return font;
}

+ (UIFont *) YSBoldSystemFontOfSize:(CGFloat)size {
    static NSMutableDictionary *fontContainer = nil;
    if (fontContainer == nil) {
        fontContainer = [[NSMutableDictionary alloc] init];
    }
    UIFont *font = [fontContainer objectForKey:[NSNumber numberWithFloat:size]];
    if (font == nil) {
        font = [UIFont boldSystemFontOfSize:size];
        [fontContainer setObject:font  forKey:[NSNumber numberWithFloat:size]];
    }
    return font;
}

@end
