//
//  YSMTCell.h
//  mapTwitter
//
//  Created by Li Yansong on 14-1-3.
//  Copyright (c) 2014年 Liyansong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+Additions.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import "SWTableViewCell.h"

@interface YSMTCell : SWTableViewCell

@property (nonatomic, strong) id info;

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *timeStampFont;
@property (nonatomic, strong) UIColor *timeStampColor;
@property (nonatomic, strong) UIFont *nameFont;
@property (nonatomic, strong) UIColor *nameColor;
@property (nonatomic, assign) CGFloat textPaddingTop;
@property (nonatomic, assign) CGFloat textPaddingLeft;
@property (nonatomic, assign) CGPoint touchLocation;

@property (nonatomic, assign) CTTextAlignment textAlignment;
@property (nonatomic, assign) BOOL underlined;

- (dispatch_queue_t) sharedContextQueue;
+ (CGPathRef)newPathForRoundedRect:(CGRect)rect radius:(CGFloat)radius;
+ (NSDictionary *) constructDefaultAttributeFont:(UIFont *) font fontColor:(UIColor *) fontColor;


- (void) setModel:(id) info;
- (void)drawInContext:(CGContextRef)ctx bounds:(CGRect)bounds text:(NSString *) text attibute:(NSDictionary *) attribute;
- (void)drawLabelInContext:(CGContextRef)ctx bounds:(CGRect)bounds text:(NSString *) text attibute:(NSDictionary *) attribute;
-(void) refreshContents;


@end
