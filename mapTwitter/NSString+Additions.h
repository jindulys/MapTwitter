//
//  NSString+Additions.h
//  mapTwitter
//
//  Created by Li Yansong on 14-1-3.
//  Copyright (c) 2014年 Liyansong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

+ (CGSize)measureFrameHeightForText:(NSString *)text
                                 font:(UIFont *)font
                   constrainedToWidth:(CGFloat)width;

@end
