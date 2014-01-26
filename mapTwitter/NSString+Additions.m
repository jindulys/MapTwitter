//
//  NSString+Additions.m
//  mapTwitter
//
//  Created by Li Yansong on 14-1-3.
//  Copyright (c) 2014年 Liyansong. All rights reserved.
//

#import "NSString+Additions.h"
#import <CoreText/CoreText.h>

@implementation NSString (Additions)

static NSMutableDictionary *defaultAttributes = nil;

+ (CGSize )measureFrameHeightForText:(NSString *)text
                                 font:(UIFont *)font
                   constrainedToWidth:(CGFloat)width {
    if ([text length] == 0)
        return CGSizeZero;
    
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef) font.fontName, font.pointSize, NULL);
    if (defaultAttributes == nil) {
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
        
        CTParagraphStyleSetting settings[] = {lineBreakMode, lineSpacing, textAlignment};
        CTParagraphStyleRef paragrapStyle = CTParagraphStyleCreate(settings, 3);
        
        defaultAttributes = [NSMutableDictionary dictionaryWithObjectsAndKeys:(__bridge_transfer id) paragrapStyle, (NSString *)kCTParagraphStyleAttributeName, nil];
    }
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithDictionary:defaultAttributes];
    [attributes setObject:(__bridge id) ctFont forKey:(NSString *)kCTFontAttributeName];
    CFRelease(ctFont);
    ctFont = NULL;
    
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attributeString);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, width, CGFLOAT_MAX));
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(framesetter);
    framesetter = NULL;
    CGPathRelease(path);
    path = NULL;
    
    CFArrayRef lines = CTFrameGetLines(textFrame);
    CGPoint lineOrigins[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), lineOrigins);
    
    CGFloat ascent, descent, leading;
    CGFloat lineHeight = font.pointSize;
    
    CGFloat currentY = 0;
    CGFloat maxWidth = 0;
    
    for (int i = 0; i < CFArrayGetCount(lines); i++) {
        CGFloat width = CTLineGetTypographicBounds(CFArrayGetValueAtIndex(lines, i), &ascent, &descent, &leading);
        currentY += lineHeight + DEFAULT_LINE_SPACE;
        maxWidth = maxWidth > width? maxWidth:width;
    }
    CFRelease(textFrame);
    textFrame = NULL;
    return CGSizeMake(maxWidth, currentY);
}

@end


