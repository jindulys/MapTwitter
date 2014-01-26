//
//  SearchHistoryCell.m
//  mapTwitter
//
//  Created by Li Yansong on 14-1-4.
//  Copyright (c) 2014年 Liyansong. All rights reserved.
//

#import "SearchHistoryCell.h"
#import "SearchInfo+create.h"

static NSMutableDictionary *defaultAttributes;
static NSMutableDictionary *timeStampAttributes;
static NSMutableDictionary *nameAttributes;

@implementation SearchHistoryCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithDesignIndex:9];
    }
    return self;
}

#pragma mark -

- (void) setModel:(SearchInfo *) info;
{
    //    self.contentView.layer.contents = nil;
    if (defaultAttributes == nil) {
        defaultAttributes = [[NSMutableDictionary alloc] initWithDictionary:
                             [[self class] constructDefaultAttributeFont:self.textFont fontColor:self.textColor]];
    }
    if (timeStampAttributes == nil) {
        timeStampAttributes = [[NSMutableDictionary alloc] initWithDictionary:
                               [[self class] constructDefaultAttributeFont:self.timeStampFont fontColor:self.timeStampColor]];
    }
    
    if (nameAttributes == nil) {
        nameAttributes = [[NSMutableDictionary alloc] initWithDictionary:[[self class]constructDefaultAttributeFont:self.nameFont fontColor:self.nameColor]];
    }
    [super setModel:info];
}


- (void)constructContents:(id) info bounds:(CGRect) bounds finishBlock:(void (^)(CGImageRef image) ) block
{
    
    SearchInfo *searchInfo = self.info;
    self.text = [searchInfo constructText];
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, YES, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithDesignIndex:9].CGColor);
    CGContextFillRect(ctx, bounds);
    CGContextRestoreGState(ctx);
    
    if (self.isHighlighted) {
        CGContextSaveGState(ctx);
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithDesignIndex:37].CGColor);
        CGContextFillRect(ctx, CGRectInset(bounds, 0, 0));
        CGContextRestoreGState(ctx);
    }
    
    CGFloat textWidth = 320 - 50 -10;
    
    [self drawLabelInContext:ctx bounds:CGRectMake(self.textPaddingLeft,self.textPaddingTop, textWidth, 16) text:searchInfo.location attibute:nameAttributes];
    
    [self drawLabelInContext:ctx bounds:CGRectMake(self.textPaddingLeft, self.textPaddingTop + 16 + 5, textWidth, 16)
                   text:self.text attibute:defaultAttributes];
    
    [self drawLabelInContext:ctx bounds:CGRectMake(self.textPaddingLeft,self.textPaddingTop+16+5+16+5, textWidth, 16) text:[searchInfo constructTweetNum] attibute:nameAttributes];
    CGImageRef imageRef = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
    UIGraphicsEndImageContext();
    
    block(imageRef);
}


@end
