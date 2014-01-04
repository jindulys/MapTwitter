//
//  UIColor+Additions.m
//  mapTwitter
//
//  Created by Li Yansong on 14-1-3.
//  Copyright (c) 2014年 Liyansong. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)

+ (UIColor *) colorWithDesignIndex:(int)index{
    
    static  NSArray *textColors = nil;
    
    if (textColors == nil) {
        //                 0             1        2         3          4
        textColors=@[@"#FFFFFF",@"#444444",@"#666666",@"#999999",@"#b8b8b8",
                     //                 5             6        7         8          9
                     @"#a48567",@"#658fae",@"#622d0a",@"#a9a9a9",@"#f6f6f6",
                     //                 10            11       12        13          14
                     @"#454545",@"#a0652f",@"#f2f2f2",@"#2d2d2d",@"#424242",
                     //                 15            16       17        18          19
                     @"#636363",@"#f5f5f5",@"#959595",@"#e1e1e1",@"#e49c54",
                     //                 20            21       22        23          24
                     @"#909090",@"#986738",@"#986738", @"#E49C54",@"EEEBE6",
                     //                 25            26       27        28          29
                     @"#9a8c7f",@"#bdb5ad",@"#eab2a5",@"#e0e0e0",@"#f4f4f4",
                     //                 30            31       32        33          34
                     @"#cd432f",@"#e69579",@"#df7859",@"#d9593d",@"#3c3c3c",
                     //                 35            36       37        38          39
                     @"#47bbc9",@"#dc593c",@"#ebebeb",@"#d5d5d5",@"#F6F6F6",
                     //                 40            41       42        43          44
                     @"#3C3C3C",@"#ffbe21",@"#FFBE21",@"#16BDBF",@"#D73D5D",
                     //                 45            46       47        48          49
                     @"#61B3D9",@"#06C6B1",@"#FFB13D",@"#D5D5D5",@"#E6E6E6",
                     //                 50            51       52        53          54
                     @"#B3D8ED",@"#1992DB",@"#C4C4C4",@"#E0E0E0",@"#EFEFEF",
                     //                 55            56       57        58          59
                     @"#55ACAA",@"#4A9695",@"#439391",@"#e5e5e5",@"#FF7800",
                     //                 60            61       62        63
                     @"#8C8C8C",@"#FF5E3B",@"#DEDEDE",@"#b4cdd7"];
    }
    
    if ( (index >= 0 && index < [textColors count]) == NO) {
        return [UIColor blackColor];
    }
    
    static NSMutableDictionary *colorContainer = nil;
    if (colorContainer == nil) {
        colorContainer = [NSMutableDictionary dictionary];
    }
    
    UIColor *retColor =  [colorContainer objectForKey:[NSNumber numberWithInt:index]];
    if (retColor == nil) {
        retColor = [UIColor colorWithHexString:textColors[index]];
        [colorContainer setObject:retColor forKey:[NSNumber numberWithInt:index]];
        return retColor;
    }else{
        return retColor;
    }
    
}

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor whiteColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor whiteColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end
