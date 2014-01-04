//
//  YSAsistance.m
//  mapTwitter
//
//  Created by Li Yansong on 14-1-3.
//  Copyright (c) 2014年 Liyansong. All rights reserved.
//

#import "YSAsistance.h"

@implementation YSAsistance

+(UIImage *) imageWithContentsOfFile:(NSString *) name;
{
    static NSBundle *YSbundle = nil;
    static UIScreen *YSScreen = nil;
    if (YSbundle == nil) {
        YSbundle = [NSBundle mainBundle];
    }
    if (YSScreen == nil) {
        YSScreen = [UIScreen mainScreen];
    }
    NSString *path = nil;
    if (YSScreen.scale == 1.0) {
        path = [YSbundle pathForResource:name ofType:@"png"];
    }else{
        path = [YSbundle pathForResource:[[NSString alloc] initWithFormat:@"%@@2x",name] ofType:@"png"];
    }
    return  [UIImage imageWithContentsOfFile:path];
}

@end
