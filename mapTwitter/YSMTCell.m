//
//  YSMTCell.m
//  mapTwitter
//
//  Created by Li Yansong on 14-1-3.
//  Copyright (c) 2014年 Liyansong. All rights reserved.
//

#import "YSMTCell.h"

@interface YSMTCell ()
{
	CTFrameRef _textFrame;
    CTFontRef _ctTextLinkFont;
    
    CGFloat _rowHeight;
    
    dispatch_queue_t _createUnderlingContextQueue;
    dispatch_source_t _source;
    
    NSMutableArray * _lines;
    NSMutableArray * _lineFrames;
    
}
@end

@implementation YSMTCell

@synthesize info = _info;
@synthesize timeStampFont = _timeStampFont;
@synthesize timeStampColor = _timeStampColor;

- (void)dealloc
{
    if (_ctTextLinkFont) {
        CFRelease(_ctTextLinkFont);
        _ctTextLinkFont = NULL;
    }
    
    if (_createUnderlingContextQueue) {
#if !OS_OBJECT_USE_OBJC
        dispatch_release(_createUnderlingContextQueue);
#endif
        _createUnderlingContextQueue = NULL;
    }
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.contentView.layer.contentsGravity = kCAGravityCenter;
        self.contentView.layer.contentsScale = [UIScreen mainScreen].scale;
        
        _textFont = [UIFont YSSystemFontOfSize:14.0f];
        _textColor = [UIColor colorWithDesignIndex:2];
        _timeStampFont = [UIFont YSSystemFontOfSize:12.0f];
        _timeStampColor = [UIColor colorWithDesignIndex:3];
        _nameFont = [UIFont YSBoldSystemFontOfSize:14.0f];
        _nameColor = [UIColor colorWithDesignIndex:34];
        _textPaddingLeft = 50.0f;
        _textPaddingTop = 12.0f;
        _underlined = NO;
        
    }
    return self;
}

#pragma mark -

- (void) setModel:(id) info;
{
    
    self.info = info;
    
    if ([[info valueForKey:@"desiredHeight"] floatValue]) {
        _rowHeight = [[info valueForKey:@"desiredHeight"] floatValue];
    }else {
        _rowHeight = 80;
    }
    
    [self refreshContents];
}


- (void)constructContents:(id) info bounds:(CGRect) bounds finishBlock:(void (^)(CGImageRef image) ) block
{
    
}

static CTLineRef ctTruncationToken = NULL;

- (void)drawLabelInContext:(CGContextRef)ctx bounds:(CGRect)bounds text:(NSString *) text attibute:(NSDictionary *) attribute;
{
    
    if ([text length]== 0) {
        return;
    }
    
    CGRect rect = CGContextGetClipBoundingBox(ctx);
    bounds.origin.y = rect.size.height - bounds.origin.y - bounds.size.height;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]
                                                  initWithString:text attributes:attribute];
    
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    if (ctTruncationToken == NULL) {
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"..." attributes:attribute];
        //        CFAttributedStringRef truncatedString = CFAttributedStringCreate(NULL, CFSTR("\u2026"), attribute);
        
        ctTruncationToken = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef) string );
    }
    CGContextSaveGState(ctx);
    CGContextConcatCTM(ctx, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, rect.size.height), 1.f, -1.f));
    CTLineRef ctLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef) attributeString );
    CTLineRef ctTruncationLine = CTLineCreateTruncatedLine(ctLine, bounds.size.width, kCTLineTruncationEnd, ctTruncationToken);
    if ( ctTruncationLine != nil )
    {
        CGContextSetTextPosition(ctx, bounds.origin.x, bounds.origin.y);
        CTLineDraw(ctTruncationLine, ctx);
        CFRelease(ctTruncationLine);
    }
    if (ctLine != nil) {
        CFRelease(ctLine);
    }
    
    CGContextRestoreGState(ctx);
}

- (void)drawInContext:(CGContextRef)ctx bounds:(CGRect)bounds text:(NSString *) text attibute:(NSDictionary *) attribute;
{
    
    if ([text length]== 0) {
        return;
    }
    CGFloat startY = bounds.origin.y;
    
    CGRect rect = CGContextGetClipBoundingBox(ctx);
    
	if (_textFrame){
		CFRelease(_textFrame);
		_textFrame = NULL;
	}
    CTFramesetterRef frameSetter = [self createFramesetter:text attribute:attribute];
	CGMutablePathRef path = CGPathCreateMutable();
    bounds.origin.y = rect.size.height - bounds.origin.y - _nameFont.pointSize;
    bounds.size.height = rect.size.height;
 	CGPathAddRect(path, NULL, bounds);
    _textFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(frameSetter);
    frameSetter = NULL;
    CGPathRelease(path);
    path = NULL;
    
    CFArrayRef lines = CTFrameGetLines(_textFrame);
	CGPoint lineOrigins[CFArrayGetCount(lines)];
	CTFrameGetLineOrigins(_textFrame, CFRangeMake(0, 0), lineOrigins);
    _lineFrames = [[NSMutableArray alloc] initWithCapacity:CFArrayGetCount(lines)];
    
	CGFloat ascent, descent, leading;
    CGPoint origin;
    CGFloat lineWidth;
    CGFloat lineHeight = self.textFont.pointSize;
    
    CGFloat currentY = _rowHeight - startY - _textFont.pointSize;
    
    for (int i = 0; i < CFArrayGetCount(lines); i++) {
        
        origin = lineOrigins[i];
        lineWidth = CTLineGetTypographicBounds(CFArrayGetValueAtIndex(lines, i), &ascent, &descent, &leading);
        //        lineHeight = ascent + descent + leading;
        [_lineFrames addObject:[NSValue valueWithCGRect:CGRectMake(origin.x +self.textPaddingLeft, currentY, lineWidth, lineHeight)]];
        currentY = currentY -  lineHeight - DEFAULT_LINE_SPACE;
        
    }
    
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    
    CGContextSaveGState(ctx);
    CGContextConcatCTM(ctx, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, rect.size.height), 1.f, -1.f));
    
    //  	CTFrameDraw(_textFrame, ctx);
    
    for (int i = 0; i < CFArrayGetCount(lines); i++) {
        
        CGPoint point = [[_lineFrames objectAtIndex:i] CGRectValue].origin;
        CGContextSetTextPosition(ctx, point.x, point.y);
        CTLineDraw(CFArrayGetValueAtIndex(lines, i), ctx);
    }
    
    CGContextRestoreGState(ctx);
}


- (CTFramesetterRef )createFramesetter:(NSString *) text attribute:(NSDictionary *) attributeDic
{
    if ([text length] == 0) {
        return NULL;
    }
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]
                                                  initWithString:text attributes:attributeDic];
    
	return CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attributeString );
}


-(void) refreshContents
{
    CGRect bounds = self.bounds;
    bounds.size.height = _rowHeight;
    if (IS_IOS_7_0_SYSTEM_AVAILABLE) {
        
        bounds.size.height -= 0.5;
        
    }
    __weak YSMTCell *myself = self;
    __weak id tagInfo = self.info;

    dispatch_async([self sharedContextQueue], ^{
        
        if (! [tagInfo isEqual:myself.info]) {
            return;
        }
        
        [myself constructContents:nil bounds:bounds finishBlock:^(CGImageRef imageRef) {
            
            if (![tagInfo isEqual:myself.info]) {
                CGImageRelease(imageRef);
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                CGRect contentFrame = myself.contentView.frame;
                contentFrame.size.width = CGImageGetWidth(imageRef)/[UIScreen mainScreen].scale;
                contentFrame.size.height = CGImageGetHeight(imageRef)/[UIScreen mainScreen].scale;
                self.contentView.frame = contentFrame;
                
                myself.contentView.layer.contents = (__bridge id) imageRef;
                CGImageRelease(imageRef);
            });
        }];
    });
}

-(void) setnameFont:(UIFont *)textLinkFont
{
    
    _nameFont = textLinkFont;
    
    if (_ctTextLinkFont != NULL) {
        CFRelease(_ctTextLinkFont);
        _ctTextLinkFont = NULL;
    }
    
    _ctTextLinkFont = CTFontCreateWithName((__bridge CFStringRef) _nameFont.fontName,
                                           _nameFont.pointSize, NULL);
}

#pragma mark - Class Function

static int i = 1;

- (dispatch_queue_t) sharedContextQueue;
{
    
    if (_createUnderlingContextQueue == NULL) {
        const char *name = [[[NSString alloc] initWithFormat:@"com.yansu.UnderingCellContextQueue_%d",i++]
                            cStringUsingEncoding:NSUTF8StringEncoding];
        _createUnderlingContextQueue = dispatch_queue_create(name, NULL);
    }
    
    return _createUnderlingContextQueue;
}



+ (CGPathRef)newPathForRoundedRect:(CGRect)rect radius:(CGFloat)radius
{
	CGMutablePathRef retPath = CGPathCreateMutable();
	
	CGRect innerRect = CGRectInset(rect, radius, radius);
	
	CGFloat inside_right = innerRect.origin.x + innerRect.size.width;
	CGFloat outside_right = rect.origin.x + rect.size.width;
	CGFloat inside_bottom = innerRect.origin.y + innerRect.size.height;
	CGFloat outside_bottom = rect.origin.y + rect.size.height;
	
	CGFloat inside_top = innerRect.origin.y;
	CGFloat outside_top = rect.origin.y;
	CGFloat outside_left = rect.origin.x;
	
	CGPathMoveToPoint(retPath, NULL, innerRect.origin.x, outside_top);
	
	CGPathAddLineToPoint(retPath, NULL, inside_right, outside_top);
	CGPathAddArcToPoint(retPath, NULL, outside_right, outside_top, outside_right, inside_top, radius);
	CGPathAddLineToPoint(retPath, NULL, outside_right, inside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_right, outside_bottom, inside_right, outside_bottom, radius);
	
	CGPathAddLineToPoint(retPath, NULL, innerRect.origin.x, outside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_bottom, outside_left, inside_bottom, radius);
	CGPathAddLineToPoint(retPath, NULL, outside_left, inside_top);
	CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_top, innerRect.origin.x, outside_top, radius);
	
	CGPathCloseSubpath(retPath);
	
	return retPath;
}

+ (NSDictionary *) constructDefaultAttributeFont:(UIFont *) font fontColor:(UIColor *) fontColor
{
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName,
                                            font.pointSize,
                                            NULL);
    
    
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByWordWrapping;
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    
    CTParagraphStyleSetting lineSpacing;
    CGFloat spacing = DEFAULT_LINE_SPACE;
    lineSpacing.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    lineSpacing.value = &spacing;
    lineSpacing.valueSize = sizeof(CGFloat);

    CTParagraphStyleSetting textAlignment;
    CTTextAlignment alignment = kCTTextAlignmentLeft;
    textAlignment.spec = kCTParagraphStyleSpecifierAlignment;
    textAlignment.value = &alignment;
    textAlignment.valueSize = sizeof(CTTextAlignment);
    
    CTParagraphStyleSetting settings[] = {lineBreakMode,lineSpacing, textAlignment};
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 3);
    
    return  [NSDictionary dictionaryWithObjectsAndKeys:
             (__bridge_transfer id) ctFont,
             (NSString *) kCTFontAttributeName,
             (__bridge id) fontColor.CGColor,
             (NSString *) kCTForegroundColorAttributeName,
             (__bridge_transfer  id) paragraphStyle,
             (NSString *)kCTParagraphStyleAttributeName,nil];
    
    
}

@end
