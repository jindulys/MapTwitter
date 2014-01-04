//
//  TweetsResultCell.m
//  mapTwitter
//
//  Created by Li Yansong on 14-1-2.
//  Copyright (c) 2014年 Liyansong. All rights reserved.
//

#import "TweetsResultCell.h"
#import "Tweet.h"
#import "UIImageView+WebCache.h"
#define kRightImageViewSize  CGSizeMake(70.f, 70.f)

@interface TweetsResultCell()
{
    //    NSString *_timeStamp;
    
    UIImageView * _avatarView;
    UIImageView *_avatarCover;
    
    NSMutableDictionary *_coverImageContainer;
    
    UIActivityIndicatorView *indicatorView;
    UIView *mask;
}

@end

static NSMutableDictionary *defaultAttributes;
static NSMutableDictionary *timeStampAttributes;
static NSMutableDictionary *nameAttributes;

@implementation TweetsResultCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 33, 33)];
        _avatarView.image = [UIImage imageNamed:@"Fanben_Avatar_Placeholder_66"];
        _avatarCover = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
        _avatarCover.image = [YSAsistance imageWithContentsOfFile:@"Fanben_Feed_Avatar_Frame_66"];
        [_avatarView addSubview:_avatarCover];
        [self.contentView addSubview:_avatarView];
        
        self.backgroundColor = [UIColor colorWithDesignIndex:9];
    }
    return self;
}

-(void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
    if (self.isHighlighted != highlighted) {
        
        if (highlighted) {
            _avatarCover.image = [UIImage imageNamed:@"Fanben_Feed_Avatar_Frame_66_Highlight"];
        }else{
            _avatarCover.image = [UIImage imageNamed:@"Fanben_Feed_Avatar_Frame_66"];
        }
        
        [super setHighlighted:highlighted animated:animated];
        [self refreshContents];
        
    }else{
        [super setHighlighted:highlighted animated:animated];
    }
    
}


#pragma mark -

- (void) setModel:(Tweet *) info;
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

    [self downloadWebImage];
    
}


-(void) downloadWebImage
{
    
    Tweet *tweet = self.info;
    _avatarView.image = [YSAsistance imageWithContentsOfFile:@"Fanben_Avatar_Placeholder_66"];
    NSString *avatarString = [[NSString alloc] initWithFormat:@"%@",tweet.profileImageURL];
    NSURL *avatarURL = [[NSURL alloc] initWithString: avatarString];
    [_avatarView setImageWithURL:avatarURL placeholderImage:
     [YSAsistance imageWithContentsOfFile:@"Fanben_Avatar_Placeholder_66"]];
}


- (void)constructContents:(id) info bounds:(CGRect) bounds finishBlock:(void (^)(CGImageRef image) ) block
{
    
    Tweet *tweet = self.info;
    self.text = tweet.text;
    
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
    
    [self drawLabelInContext:ctx bounds:CGRectMake(self.textPaddingLeft,self.textPaddingTop, textWidth, tweet.nameHeight) text:tweet.name attibute:nameAttributes];
    
    [self drawInContext:ctx bounds:CGRectMake(self.textPaddingLeft, self.textPaddingTop + tweet.nameHeight + 5, textWidth, tweet.contentHeight)
                   text:self.text attibute:defaultAttributes];
    CGImageRef imageRef = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
    UIGraphicsEndImageContext();
    
    block(imageRef);
}

@end
